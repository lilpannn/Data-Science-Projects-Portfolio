#!/usr/bin/env python3

''' Outputs the Newick formatted tree after performing the neighbor-joining
    algorithm on an arbitrary number of species.

Arguments:
    -f: distances file (symmetric matrix with 0 on the diagonal)
        (default is dist10.txt)
Outputs:
    Newick formatted tree after neighbor-joining

Example usage:
    python 1a.py -f dist10.txt
'''

import argparse
import numpy as np
from copy import deepcopy



''' Reads the input file of distances between the sequences

Arguments:
    distances_file: file name of distances between sequences
Returns:
    D: matrix of distances (map of maps)
    mapping: index to name mapping (dictionary)
'''
def read_data(distances_file):
    with open(distances_file, "r") as f:
        lines = [l.strip().split() for l in f.readlines()]
        mapping = {i: s for i, s in enumerate(lines[0])}
        lines = [l[1:] for l in lines[1:]]
        D = {i: {} for i in range(len(lines))}
        for i, l in enumerate(lines):
            for j, sval in enumerate(l):
                D[i][j] = float(sval)
    return D, mapping


''' Performs the neighbor joining algorithm on a given set of sequences.

Arguments:
    D: map of maps, defining distances between the sequences
       (initially n x n, symmetric, 0 on the diagonal)
       (index -> index -> distance)
Returns:
    root: desired root for the tree
    edges: edges in the tree
    D: Updated distance matrix from the Neighbor Joining step (dictionary of dictionary)
'''
def neighbor_join(D):
    ''' Complete this function. '''
    D_update = deepcopy(D)
    r = len(D)
    l = 0
    edges = []
    #tip = list(D.keys())
    while (len(D_update) > 2):
        n = len(D_update)
        q = np.zeros((n,n))
        row_key = list(D_update.keys())
        col_key = list(D_update.keys())
 
        #Q Matrix
        for i in range(n):
            row = row_key[i]
            for j in range(n):
                col = col_key[j]
                if i==j:
                    q[i,j] = 0
                else:
                    d_ik = 0
                    d_jk = 0
                    for k in range(n):
                        k = row_key[k]
                        d_ik += D_update[row][k]
                        d_jk += D_update[col][k]
                #assign q value
                    q[i,j] = (n-2)*D_update[row][col]- d_ik - d_jk
        #Locate min_pair
        a,b = np.argwhere(q == np.min(q))[0]
        min_pair = [row_key[a], col_key[b]]
        x, y = min_pair[0], min_pair[1]
        #Calculate distance between min_pair and two nodes
        d_xk = 0
        d_yk = 0
        for i in min_pair:
            i_row = list(D_update[i].values())
            for j in i_row:
                if (i==min_pair[0]):
                    d_xk += j
                else:
                    d_yk += j
        d_xy = D_update[min_pair[0]].get(min_pair[1])
        d_xz = 1/2*d_xy + 1/(2*(n-2))*(d_xk-d_yk)
        d_yz = d_xy - d_xz

        z = r + l

        D_update[z] = {}
        for i in D_update.keys():
            if i != z:
                d_ui = 1/2*(D_update[x][i]+D_update[y][i]-D_update[x][y]) ##D
                D_update[i][z] = d_ui
                D_update[z][i] = d_ui
            else:
                D_update[z][i] = 0

        rem = []
        for i in D_update:
            for j in D_update:
                if i in min_pair or j in min_pair:
                    D_update[i].pop(j)
            if D_update[i] == {}:
                rem.append(i)
        for key in rem:
            D_update.pop(key)
        
        edges.append((x,z))
        edges.append((y,z))

        D[z] = {}
        D[z][z] = 0
        D[z][x] = d_xz
        D[x][z] = d_xz
        D[z][y] = d_yz
        D[y][z] = d_yz

        l = l+1
#end of loop ##############
 
    fin_nodes = list(D_update.keys())
    #edges.append(tuple(fin_nodes))
    fin_dist = D_update[fin_nodes[0]][fin_nodes[1]]/2.0
    root = 2*r+1
    D[root] = {}
    for i in fin_nodes:
        D[root][i] = fin_dist
        D[i][root] = fin_dist
        edges.append((root,i))


    return root, edges, D


''' Helper function for defining a tree data structure.
    First finds the edge to add a root node to and then generates binary tree.
    Root node should be at the midpoint of the last added edge.

Arguments:
    root: desired root for the tree
    edges: edges in the tree
Returns:
    tree_map: map of a tree from nodes to the children (leaves have empty list of children)
'''
def assemble_tree(root,edges):   ### FROM SECTION 6
    ''' Complete this function. '''
    tree_map = {}
    queue = [root]
    while queue:
        curr_node = queue.pop(0)
        tree_map[curr_node] = []
        for (i,j) in edges:
            if i == curr_node and j not in tree_map:
                tree_map[curr_node].append(j)
                queue.append(j)
            if j == curr_node and i not in tree_map:
                tree_map[curr_node].append(i)
                queue.append(i)
    return tree_map


''' Returns a string of the Newick tree format for the tree rooted at `root`.

Arguments:
    root: desired root for the tree
    tree_map: map of a tree from nodes to the children (leaves have empty list of children)
    D: Updated distance matrix from the Neighbor Joining step (dictionary of dictionary)
    mapping: index to name mapping (dictionary)
Returns:
    output: rooted tree in Newick tree format (string)
'''
def generate_newick(root, tree_map, D, mapping = None): ### FROM SECTION 6
    def display(root,tree_map,D):
        if len(tree_map[root]) == 0:
            if mapping == None:
                return str(root)
            else:
                return mapping[root]
        if len(tree_map[root]) == 1:
            return ('%s:%.6f' % (display(tree_map[root][0], tree_map, D), 
                                D[root][tree_map[root][0]]))
        
        [left_child,right_child] = tree_map[root]
        return '(%s:%.6f, %s:%.6f)' % (display(left_child, tree_map, D), 
                                D[root][left_child], display(right_child, tree_map, D), 
                                D[root][right_child])

    return '%s;' % display(root,tree_map, D)



def main():
    parser = argparse.ArgumentParser(
        description='Neighbor-joining algorithm on a set of n sequences')
    parser.add_argument('-f', action="store", dest="f", type=str, default='dist10.txt')
    args = parser.parse_args()
    distances_file = args.f

    D, mapping = read_data(distances_file)
    root, edges, D = neighbor_join(D) 
    tree_map = assemble_tree(root,edges)
    nwk_str = generate_newick(root, tree_map, D, mapping) 
    
    # Print and save the Newick string.
    print(nwk_str)
    with open("tree.nwk", "w") as nwk_file:
        print(nwk_str, file=nwk_file)


if __name__ == "__main__":
    main()
