#!/usr/bin/env python3

''' Find the maximum likelihood tree for four sequences on the Jukes-Cantor
    model using Felsenstein's algorithm.

Arguments:
    -f: fasta file containing the multiple alignment
        (default is apoe.fasta)
Outputs:
    likelihoods for three topologies in Figure 1 of pset3

Example Usage:
    python 2a.py -f test.fasta
'''

import argparse
import numpy as np


class Node():
    ''' Initializes a node with given parameters.

    Arguments:
        name: name of node (only relevant for leaves)
        left: left child (Node)
        right: right child (Node)
        branch_length: length of branch that leads to this node (float)
        branch_id: id of branch that leads to this node (int)
        probs: probability of observed bases beneath this node
                [list of 4 probs for 'ACGT'] (initialized to None)
    '''
    def __init__(self, name, left, right, branch_length, branch_id):
        self.name = name
        self.left = left
        self.right = right
        self.branch_length = branch_length
        self.branch_id = branch_id
        self.probs = [None for _ in range(4)]


''' Reads data from ```filename``` in fasta format.

Arguments:
    filename: name of fasta file to read
Returns:
    sequences: dictionary of outputs (string (sequence id) -> sequence (string))
    size: length of each sequence
'''
def read_data(filename):
    with open(filename, "r") as f:
        lines = f.readlines()
        sequences = {}
        output = ""
        size = 0
        curr = ""
        flag = False
        for l in lines:
            if l[0] == ">": 
                if (len(output) != 0):
                    sequences[curr] = output
                    size = len(output)
                    output = ""
                curr = l[2:].strip()
            else:
                output += l.strip()
        sequences[curr] = output
    return sequences, size


''' Evaluates P(b|a, t) under the Jukes-Cantor model

Arguments:
    b: descendant base (string)
    a: ancestral base (string)
    t: branch length (float)
    u: mutation rate (float, defaults to 1)
Returns:
    prob: float probability P(b|a, t)
'''
def jcm(b, a, t, u = 1.0):
    ''' Complete this function. '''
    if b == a:
        return 1/4*(1+3*np.exp(-4/3*t*u))
    else:
        return 1/4*(1-np.exp(-4/3*t*u))



''' Constructs the ordering of the post-order traversal of ```index```
    topology from the pset.
Arguments:
    index: which topology to use
Returns:
    list of Nodes corresponding to post-order traversal of the topology
    branch_probs: 6x4x4 matrices, indexed as:
                  branch_probs[branch_id][a][b] = P(b | a, t_branch_id)
'''
def initialize_topology(index):
    bases = 'ACGT'

    branch_lengths = np.array(
        [[0.07517, 0.03059, 0.03161, 0.11761, 0.14289],
        [0.20843, 0.03397, 0.03497, 0.24952, 0.00000],
        [0.20843, 0.03397, 0.03497, 0.24952, 0.00000]], dtype = float)

    names = ['human', 'mouse', 'rat', 'dog']
    branches = [0, 1, 2, 3]
    leaves = [Node(s, None, None, bl, i) for (s, i, bl) in 
                zip(names, branches, branch_lengths[index, :])]
    ordering = None
    branch_probs = [np.zeros((4,4), dtype = float) for _ in range(6)]
    # Note that branch 5 (or 6 in 1-index) is the branch of 0-length
    if (index == 0):
        hum_dog = Node(None, leaves[0], leaves[3], 0, 5)
        mouse_rat = Node(None, leaves[1], leaves[2], branch_lengths[index,4], 4)
        root = Node('root', hum_dog, mouse_rat, None, None)
        ordering = [leaves[0], leaves[3], hum_dog, leaves[1], leaves[2], \
                    mouse_rat, root]
    elif (index == 1):
        hum_mouse = Node(None, leaves[0], leaves[1], 0, 5)
        rat_dog = Node(None, leaves[2], leaves[3], branch_lengths[index, 4], 4)
        root = Node('root', hum_mouse, rat_dog, None, None)
        ordering = [leaves[0], leaves[1], hum_mouse, leaves[2], leaves[3], \
                    rat_dog, root]
    else:
        mouse_dog = Node(None, leaves[1], leaves[3], 0, 5)
        hum_rat = Node(None, leaves[0], leaves[2], branch_lengths[index, 4], 4)
        root = Node('root', mouse_dog, hum_rat, None, None)
        ordering = [leaves[1], leaves[3], mouse_dog, leaves[0], leaves[2], \
                    hum_rat, root]

    ''' Assign 6x4x4 branch_probs values: branch_probs[branch_id][ancestor_base][descendant_base] '''
    for branch in range(len(branch_lengths[index])+1):
        if branch < len(branch_lengths[index]):
            branch_len = branch_lengths[index][branch]
        else:
            branch_len = 0  ###taking care of the sixth matrix
        for anc in range(4):
            for des in range(4):
                branch_probs[branch][anc][des] = jcm(des,anc,branch_len)
    return ordering, branch_probs


''' Computes the likelihood of the data given the topology specified by ordering

Arguments:
    data: sequence data (dict: name of sequence owner -> sequence)
    seqlen: length of sequences
    ordering: postorder traversal of our topology
    bp: branch probabilities for the given branches: 6x4x4 matrix indexed as
        branch_probs[branch_id][a][b] = P(b | a, t_branch_id)
Returns:
    total_log_prob: log likelihood of the topology given the sequence data
'''
def likelihood(data, seqlen, ordering, bp):
    ''' Complete this function. '''
    total_log_prob = 0.0  # Initialize the total log likelihood
    bases = ['A','C','G','T']
    for dat in range(seqlen):
        for node in ordering:
            if (node.left == None and node.right == None):
                #assigne leaf probability based on its base pair
                for i in range(len(node.probs)):
                    if i == bases.index(data[node.name][dat]):
                        node.probs[i] = 1
                    else:
                        node.probs[i] = 0
            else:

                for i in range(len(node.probs)):
                    left = np.zeros(4)
                    right = np.zeros(4)
                    s = i
                    #for ACGT in inner node's probability
                    for j in range(len(bases)):
                        x = j
                        left[i] += bp[node.left.branch_id][x][s]*node.left.probs[x]
                        right[i]+= bp[node.right.branch_id][x][s]*node.right.probs[x]
                    
                    node.probs[i] = np.sum(left)*np.sum(right)

            if node.name == 'root':
                total_log_prob += np.log(0.25*sum(node.probs))
    return total_log_prob
                

def main():
    parser = argparse.ArgumentParser(
        description='Compute the likelihood of the three topologies in Figure 1 given the alignment.')
    parser.add_argument('-f', action="store", dest="f", type=str, default='apoe.fasta')

    args = parser.parse_args()
    fasta_file = args.f

    data, seqlen = read_data(fasta_file)
    for i in range(3):
        ordering, probs = initialize_topology(i)
        the_likelihood = likelihood(data, seqlen, ordering, probs)
        print("Log likelihood for topology %d is %.2f" % (i+1, the_likelihood))


if __name__ == "__main__":
    main()
