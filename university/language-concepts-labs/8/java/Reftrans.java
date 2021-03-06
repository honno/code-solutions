import java.util.List;
import java.util.ArrayList;

public class Reftrans
{
    private static class IntHolder {
      public int i;
      public IntHolder(int i) { this.i = i; }
    }

    public static void main(String[] args)
    {
        IntHolder a;

        // create an int holder:
        a = new IntHolder(1);

        int result1 = a.i;
        a.i += 1;
        result1 += a.i;
          // (a.i++) + a.i;  // not referentially transparent
        // TASK 8.2 (a): rewrite the above 2 lines using referentially transparent expressions


        // create exactly the same int holder as before:
        a = new IntHolder(1);

        // like above but swapped the order of addition:
        int result2 =
            a.i + a.i;
        a.i += 1;
          // a.i + (a.i++);  // not referentially transparent
        // TASK 8.2 (a): rewrite the above 2 lines using referentially transparent expressions

        System.out.println("result1 = " + result1);
        System.out.println("result2 = " + result2);
    }

}
