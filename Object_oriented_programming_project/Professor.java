package cs2110;

import java.util.Objects;

/**
 * A professor, with attributes such as their name and the year they received their PhD.
 */
public final class Professor implements Comparable<Professor> {

    /**
     * Full name of this professor.  Must not be empty.
     */
    private final String name;

    /**
     * Year in which this node's professor was awarded their PhD.
     */
    private final int phdYear;

    /**
     * Create a new professor with name `name` who earned their PhD in year `year`.  Requires `name`
     * is not empty.
     */
    public Professor(String name, int phdYear) {
        assert name != null && !name.isEmpty();
        this.name = name;
        this.phdYear = phdYear;
    }

    /**
     * Create a copy of `prof`.
     */
    Professor(Professor prof) {
        // Normally immutable types do not benefit from a copy constructor.  This one is here to
        // assist in testing (which is why it also copies an immutable String).  Constructing copies
        // helps test cases ensure that `.equals()` is being used instead of `==` when needed.
        name = new String(prof.name);
        phdYear = prof.phdYear;
    }

    /**
     * Return this professor's name.
     */
    public String name() {
        return name;
    }

    /**
     * Return the year in which this professor earned their PhD.
     */
    public int phdYear() {
        return phdYear;
    }

    /**
     * Return a String representation of this Professor that includes their name and degree year.
     */
    @Override
    public String toString() {
        return name + " (" + phdYear + ")";
    }

    @Override
    public boolean equals(Object ob) {
        if (ob == null || !this.getClass().equals(ob.getClass())) {
            return false;
        }

        Professor other = (Professor) ob;
        return name.equals(other.name) && phdYear == other.phdYear;
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, phdYear);
    }

    /**
     * Compare this professor to `other` and return a negative number if `this` precedes `other`, a
     * positive number of `this` succeeds `other`, and 0 if they are equal. They are ordered
     * chronologically by the year they earned their PhD, then alphabetically by name.
     */
    @Override
    public int compareTo(Professor other) {
        int c = Integer.compare(phdYear, other.phdYear);
        return (c != 0) ? c : name.compareTo(other.name);
    }
}
