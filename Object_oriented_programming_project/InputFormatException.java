package cs2110;

/**
 * An exception representing malformed input, such as reading from a file that is not in the right
 * format.
 */
public class InputFormatException extends Exception {

    /**
     * Create a new InputFormatException with user-interpretable message `message`.
     */
    public InputFormatException(String message) {
        super(message);
    }
}
