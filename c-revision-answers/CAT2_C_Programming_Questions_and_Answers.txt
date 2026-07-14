# CAT 2 Practice Questions — C Programming
## ULK Polytechnic Institute (UPI)
### Department of Electrical and Electronics Engineering

---

# COG — Variables, Data Types, Operators and Functions

---

### 1. Write a Program that declares an integer variable called age and assigns it the value 20. Display the value.

**Answer:**

```c
#include <stdio.h>

int main() {
    int age = 20;
    printf("Age = %d\n", age);
    return 0;
}
```

---

### 2. Write a Program that declares a local variable and a global variable. Display both values.

**Answer:**

```c
#include <stdio.h>

int globalVar = 100; /* global variable */

int main() {
    int localVar = 50; /* local variable */
    printf("Global variable = %d\n", globalVar);
    printf("Local variable = %d\n", localVar);
    return 0;
}
```

---

### 3. Write a Program that accepts two integers and displays their sum.

**Answer:**

```c
#include <stdio.h>

int main() {
    int a, b, sum;
    printf("Enter two integers: ");
    scanf("%d %d", &a, &b);
    sum = a + b;
    printf("Sum = %d\n", sum);
    return 0;
}
```

---

### 4. Write a Program that accepts a float value and displays it to two decimal places.

**Answer:**

```c
#include <stdio.h>

int main() {
    float num;
    printf("Enter a float value: ");
    scanf("%f", &num);
    printf("Value = %.2f\n", num);
    return 0;
}
```

---

### 5. Write a Program that demonstrates the use of the following operators:
a. Addition  
b. Subtraction  
c. Multiplication  
d. Division

**Answer:**

```c
#include <stdio.h>

int main() {
    int a = 20, b = 5;
    printf("Addition: %d + %d = %d\n", a, b, a + b);
    printf("Subtraction: %d - %d = %d\n", a, b, a - b);
    printf("Multiplication: %d * %d = %d\n", a, b, a * b);
    printf("Division: %d / %d = %d\n", a, b, a / b);
    return 0;
}
```

---

### 6. Write a Program that finds the remainder when 25 is divided by 4.

**Answer:**

```c
#include <stdio.h>

int main() {
    int remainder = 25 % 4;
    printf("Remainder of 25 divided by 4 = %d\n", remainder);
    return 0;
}
```

---

### 7. Write a Program that compares two numbers and displays whether they are equal or not.

**Answer:**

```c
#include <stdio.h>

int main() {
    int a, b;
    printf("Enter two numbers: ");
    scanf("%d %d", &a, &b);

    if (a == b)
        printf("The numbers are equal.\n");
    else
        printf("The numbers are not equal.\n");

    return 0;
}
```

---

### 8. Write a Program that demonstrates the use of logical AND (&&) and OR (||) operators.

**Answer:**

```c
#include <stdio.h>

int main() {
    int a = 10, b = 5, c = 0;

    if (a > 0 && b > 0)
        printf("AND: Both a and b are positive.\n");

    if (a > 0 || c > 0)
        printf("OR: At least one of a or c is positive.\n");

    return 0;
}
```

---

### 9. Write a Program that uses the assignment operators += and -=.

**Answer:**

```c
#include <stdio.h>

int main() {
    int x = 10;
    printf("Initial x = %d\n", x);

    x += 5; /* x = x + 5 */
    printf("After x += 5: %d\n", x);

    x -= 3; /* x = x - 3 */
    printf("After x -= 3: %d\n", x);

    return 0;
}
```

---

### 10. Write a user-defined function called square() that returns the square of a number.

**Answer:**

```c
#include <stdio.h>

int square(int n) {
    return n * n;
}

int main() {
    int num;
    printf("Enter a number: ");
    scanf("%d", &num);
    printf("Square of %d = %d\n", num, square(num));
    return 0;
}
```

---

# PROJECT-DIAGRAM — Flowcharts and Program Development

---

### 11. Draw a flowchart for calculating the area of a rectangle.

**Answer:**

```
        Start
          |
          v
   Input length (L)
          |
          v
   Input width (W)
          |
          v
   Area = L * W
          |
          v
   Display Area
          |
          v
         End
```

---

### 12. Draw a flowchart for finding the largest of two numbers.

**Answer:**

```
        Start
          |
          v
     Input A, B
          |
          v
      Is A > B ?
         / \
       Yes  No
        |    |
        v    v
   Display  Display
   A is     B is
   largest  largest
        \    /
          v
         End
```

---

### 13. Write the pseudocode for calculating the average of three numbers.

**Answer:**

```
START
  PROMPT "Enter three numbers"
  READ n1, n2, n3
  sum = n1 + n2 + n3
  average = sum / 3
  DISPLAY average
END
```

---

### 14. Draw a flowchart for calculating a student’s total marks.

**Answer:**

```
        Start
          |
          v
 Input mark1, mark2, mark3
          |
          v
 total = mark1 + mark2 + mark3
          |
          v
   Display total
          |
          v
         End
```

---

### 15. Write a Program that calculates the area of a circle.

**Answer:**

```c
#include <stdio.h>
#define PI 3.14159

int main() {
    float radius, area;
    printf("Enter radius: ");
    scanf("%f", &radius);
    area = PI * radius * radius;
    printf("Area of circle = %.2f\n", area);
    return 0;
}
```

---

### 16. Write a Program that converts Celsius temperature into Fahrenheit.

**Answer:**

```c
#include <stdio.h>

int main() {
    float celsius, fahrenheit;
    printf("Enter temperature in Celsius: ");
    scanf("%f", &celsius);
    fahrenheit = (celsius * 9 / 5) + 32;
    printf("Fahrenheit = %.2f\n", fahrenheit);
    return 0;
}
```

---

### 17. Write a Program that calculates simple interest.

**Answer:**

```c
#include <stdio.h>

int main() {
    float principal, rate, time, interest;
    printf("Enter principal, rate, and time: ");
    scanf("%f %f %f", &principal, &rate, &time);
    interest = (principal * rate * time) / 100;
    printf("Simple Interest = %.2f\n", interest);
    return 0;
}
```

---

### 18. Write a Program that calculates the perimeter of a rectangle.

**Answer:**

```c
#include <stdio.h>

int main() {
    float length, width, perimeter;
    printf("Enter length and width: ");
    scanf("%f %f", &length, &width);
    perimeter = 2 * (length + width);
    printf("Perimeter = %.2f\n", perimeter);
    return 0;
}
```

---

### 19. Write a Program that calculates the volume of a cube.

**Answer:**

```c
#include <stdio.h>

int main() {
    float side, volume;
    printf("Enter side of cube: ");
    scanf("%f", &side);
    volume = side * side * side;
    printf("Volume of cube = %.2f\n", volume);
    return 0;
}
```

---

### 20. Write a Program that accepts a student’s name and marks and displays them.

**Answer:**

```c
#include <stdio.h>

int main() {
    char name[50];
    float marks;
    printf("Enter student name: ");
    scanf("%s", name);
    printf("Enter marks: ");
    scanf("%f", &marks);
    printf("Name: %s\n", name);
    printf("Marks: %.2f\n", marks);
    return 0;
}
```

---

# CODE-BRANCH — Control Statements

---

### 21. Write a Program that checks whether a number is positive or negative using an if statement.

**Answer:**

```c
#include <stdio.h>

int main() {
    int num;
    printf("Enter a number: ");
    scanf("%d", &num);

    if (num > 0)
        printf("Positive number\n");
    if (num < 0)
        printf("Negative number\n");
    if (num == 0)
        printf("Zero\n");

    return 0;
}
```

---

### 22. Write a Program that determines whether a student has passed or failed using an if-else statement.

**Answer:**

```c
#include <stdio.h>

int main() {
    float marks;
    printf("Enter marks: ");
    scanf("%f", &marks);

    if (marks >= 50)
        printf("Passed\n");
    else
        printf("Failed\n");

    return 0;
}
```

---

### 23. Write a Program that assigns grades using an if-else-if ladder.

**Answer:**

```c
#include <stdio.h>

int main() {
    float marks;
    printf("Enter marks: ");
    scanf("%f", &marks);

    if (marks >= 80)
        printf("Grade: A\n");
    else if (marks >= 70)
        printf("Grade: B\n");
    else if (marks >= 60)
        printf("Grade: C\n");
    else if (marks >= 50)
        printf("Grade: D\n");
    else
        printf("Grade: F\n");

    return 0;
}
```

---

### 24. Write a Program that finds the largest of three numbers using nested if statements.

**Answer:**

```c
#include <stdio.h>

int main() {
    int a, b, c;
    printf("Enter three numbers: ");
    scanf("%d %d %d", &a, &b, &c);

    if (a >= b) {
        if (a >= c)
            printf("Largest = %d\n", a);
        else
            printf("Largest = %d\n", c);
    } else {
        if (b >= c)
            printf("Largest = %d\n", b);
        else
            printf("Largest = %d\n", c);
    }

    return 0;
}
```

---

### 25. Write a Program that displays numbers from 1 to 10 using a for loop.

**Answer:**

```c
#include <stdio.h>

int main() {
    int i;
    for (i = 1; i <= 10; i++) {
        printf("%d ", i);
    }
    printf("\n");
    return 0;
}
```

---

### 26. Write a Program that displays even numbers between 1 and 50 using a while loop.

**Answer:**

```c
#include <stdio.h>

int main() {
    int i = 2;
    while (i <= 50) {
        printf("%d ", i);
        i += 2;
    }
    printf("\n");
    return 0;
}
```

---

### 27. Write a Program that displays odd numbers between 1 and 100 using a do-while loop.

**Answer:**

```c
#include <stdio.h>

int main() {
    int i = 1;
    do {
        printf("%d ", i);
        i += 2;
    } while (i <= 100);
    printf("\n");
    return 0;
}
```

---

### 28. Write a Program that calculates the sum of numbers from 1 to 100 using a loop.

**Answer:**

```c
#include <stdio.h>

int main() {
    int i, sum = 0;
    for (i = 1; i <= 100; i++) {
        sum += i;
    }
    printf("Sum = %d\n", sum);
    return 0;
}
```

---

### 29. Write a Program that demonstrates the use of the break statement.

**Answer:**

```c
#include <stdio.h>

int main() {
    int i;
    for (i = 1; i <= 10; i++) {
        if (i == 5)
            break;
        printf("%d ", i);
    }
    printf("\nLoop stopped using break.\n");
    return 0;
}
```

---

### 30. Write a Program that demonstrates the use of the continue statement.

**Answer:**

```c
#include <stdio.h>

int main() {
    int i;
    for (i = 1; i <= 10; i++) {
        if (i == 5)
            continue;
        printf("%d ", i);
    }
    printf("\n5 was skipped using continue.\n");
    return 0;
}
```

---

### 31. Write a menu-driven Program using a switch statement for:
a. Addition  
b. Subtraction  
c. Multiplication  
d. Division

**Answer:**

```c
#include <stdio.h>

int main() {
    int choice;
    float a, b;

    printf("Menu:\n");
    printf("1. Addition\n");
    printf("2. Subtraction\n");
    printf("3. Multiplication\n");
    printf("4. Division\n");
    printf("Enter choice: ");
    scanf("%d", &choice);

    printf("Enter two numbers: ");
    scanf("%f %f", &a, &b);

    switch (choice) {
        case 1:
            printf("Result = %.2f\n", a + b);
            break;
        case 2:
            printf("Result = %.2f\n", a - b);
            break;
        case 3:
            printf("Result = %.2f\n", a * b);
            break;
        case 4:
            if (b != 0)
                printf("Result = %.2f\n", a / b);
            else
                printf("Error: Division by zero\n");
            break;
        default:
            printf("Invalid choice\n");
    }

    return 0;
}
```

---

### 32. Write a Program that demonstrates the use of a goto statement.

**Answer:**

```c
#include <stdio.h>

int main() {
    int num;
    printf("Enter a positive number: ");
    scanf("%d", &num);

    if (num < 0)
        goto error;

    printf("You entered: %d\n", num);
    return 0;

error:
    printf("Error: Negative number not allowed.\n");
    return 1;
}
```

---

# CUBES — Functions

---

### 33. Write a user-defined function that calculates the sum of two integers.

**Answer:**

```c
#include <stdio.h>

int add(int x, int y) {
    return x + y;
}

int main() {
    int a, b;
    printf("Enter two integers: ");
    scanf("%d %d", &a, &b);
    printf("Sum = %d\n", add(a, b));
    return 0;
}
```

---

### 34. Write a function that calculates the average of five numbers.

**Answer:**

```c
#include <stdio.h>

float average(float a, float b, float c, float d, float e) {
    return (a + b + c + d + e) / 5;
}

int main() {
    float n1, n2, n3, n4, n5;
    printf("Enter five numbers: ");
    scanf("%f %f %f %f %f", &n1, &n2, &n3, &n4, &n5);
    printf("Average = %.2f\n", average(n1, n2, n3, n4, n5));
    return 0;
}
```

---

### 35. Write a recursive function that calculates the factorial of a number.

**Answer:**

```c
#include <stdio.h>

long factorial(int n) {
    if (n == 0 || n == 1)
        return 1;
    else
        return n * factorial(n - 1);
}

int main() {
    int num;
    printf("Enter a number: ");
    scanf("%d", &num);
    printf("Factorial of %d = %ld\n", num, factorial(num));
    return 0;
}
```

---

### 36. Write a Program that demonstrates Call by Value.

**Answer:**

```c
#include <stdio.h>

void change(int x) {
    x = x + 10;
    printf("Inside function: x = %d\n", x);
}

int main() {
    int a = 5;
    printf("Before call: a = %d\n", a);
    change(a);
    printf("After call: a = %d\n", a);
    return 0;
}
```

---

### 37. Write a Program that demonstrates Call by Reference.

**Answer:**

```c
#include <stdio.h>

void change(int *x) {
    *x = *x + 10;
    printf("Inside function: x = %d\n", *x);
}

int main() {
    int a = 5;
    printf("Before call: a = %d\n", a);
    change(&a);
    printf("After call: a = %d\n", a);
    return 0;
}
```

---

### 38. Write a Program that uses getchar() to read a character and display it.

**Answer:**

```c
#include <stdio.h>

int main() {
    char ch;
    printf("Enter a character: ");
    ch = getchar();
    printf("You entered: %c\n", ch);
    return 0;
}
```

---

### 39. Write a Program that uses putchar() to display a character.

**Answer:**

```c
#include <stdio.h>

int main() {
    char ch = 'A';
    printf("Character: ");
    putchar(ch);
    putchar('\n');
    return 0;
}
```

---

### 40. Write a Program that uses gets() and puts() to accept and display a student’s name.

**Answer:**

```c
#include <stdio.h>

int main() {
    char name[50];
    printf("Enter student name: ");
    gets(name);
    printf("Student name: ");
    puts(name);
    return 0;
}
```

---

# Layer-Group — Advanced Topics

---

### B1. Write a Program that stores 10 integers in a one-dimensional array and displays them.

**Answer:**

```c
#include <stdio.h>

int main() {
    int arr[10], i;
    printf("Enter 10 integers:\n");
    for (i = 0; i < 10; i++) {
        scanf("%d", &arr[i]);
    }
    printf("Array elements:\n");
    for (i = 0; i < 10; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    return 0;
}
```

---

### B2. Write a Program that stores marks of 3 students in a two-dimensional array.

**Answer:**

```c
#include <stdio.h>

int main() {
    float marks[3][3];
    int i, j;

    for (i = 0; i < 3; i++) {
        printf("Enter 3 marks for student %d:\n", i + 1);
        for (j = 0; j < 3; j++) {
            scanf("%f", &marks[i][j]);
        }
    }

    printf("\nMarks table:\n");
    for (i = 0; i < 3; i++) {
        printf("Student %d: ", i + 1);
        for (j = 0; j < 3; j++) {
            printf("%.1f ", marks[i][j]);
        }
        printf("\n");
    }

    return 0;
}
```

---

### B3. Write a Program that demonstrates pointer arithmetic.

**Answer:**

```c
#include <stdio.h>

int main() {
    int arr[5] = {10, 20, 30, 40, 50};
    int *ptr = arr;
    int i;

    printf("Using pointer arithmetic:\n");
    for (i = 0; i < 5; i++) {
        printf("*(ptr + %d) = %d\n", i, *(ptr + i));
    }

    return 0;
}
```

---

### B4. Write a Program that swaps two numbers using pointers.

**Answer:**

```c
#include <stdio.h>

void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int main() {
    int x = 10, y = 20;
    printf("Before swap: x = %d, y = %d\n", x, y);
    swap(&x, &y);
    printf("After swap: x = %d, y = %d\n", x, y);
    return 0;
}
```

---

### B5. Create a structure called Student containing:
a. Registration Number  
b. Name  
c. Marks  

Accept and display data for 5 students.

**Answer:**

```c
#include <stdio.h>

struct Student {
    int regNo;
    char name[50];
    float marks;
};

int main() {
    struct Student s[5];
    int i;

    for (i = 0; i < 5; i++) {
        printf("\nStudent %d:\n", i + 1);
        printf("Registration Number: ");
        scanf("%d", &s[i].regNo);
        printf("Name: ");
        scanf("%s", s[i].name);
        printf("Marks: ");
        scanf("%f", &s[i].marks);
    }

    printf("\n--- Student Records ---\n");
    for (i = 0; i < 5; i++) {
        printf("RegNo: %d | Name: %s | Marks: %.2f\n",
               s[i].regNo, s[i].name, s[i].marks);
    }

    return 0;
}
```

---

### B6. Write a Program that creates a CSV file and stores student records.

**Answer:**

```c
#include <stdio.h>

int main() {
    FILE *fp;
    int i, regNo;
    char name[50];
    float marks;

    fp = fopen("students.csv", "w");
    if (fp == NULL) {
        printf("Error opening file\n");
        return 1;
    }

    fprintf(fp, "RegNo,Name,Marks\n");

    for (i = 0; i < 3; i++) {
        printf("Enter RegNo, Name, Marks: ");
        scanf("%d %s %f", &regNo, name, &marks);
        fprintf(fp, "%d,%s,%.2f\n", regNo, name, marks);
    }

    fclose(fp);
    printf("Records saved to students.csv\n");
    return 0;
}
```

---

### B7. Write a Program that reads data from a CSV file and displays it.

**Answer:**

```c
#include <stdio.h>

int main() {
    FILE *fp;
    char line[200];

    fp = fopen("students.csv", "r");
    if (fp == NULL) {
        printf("Error opening file\n");
        return 1;
    }

    printf("--- CSV File Contents ---\n");
    while (fgets(line, sizeof(line), fp) != NULL) {
        printf("%s", line);
    }

    fclose(fp);
    return 0;
}
```

---

### B8. Write a Program that writes examination results into a text file.

**Answer:**

```c
#include <stdio.h>

int main() {
    FILE *fp;
    char name[50];
    float marks;
    int i;

    fp = fopen("results.txt", "w");
    if (fp == NULL) {
        printf("Error opening file\n");
        return 1;
    }

    fprintf(fp, "EXAMINATION RESULTS\n");
    fprintf(fp, "-------------------\n");

    for (i = 0; i < 3; i++) {
        printf("Enter name and marks: ");
        scanf("%s %f", name, &marks);
        fprintf(fp, "Name: %s | Marks: %.2f | Status: %s\n",
                name, marks, (marks >= 50) ? "PASS" : "FAIL");
    }

    fclose(fp);
    printf("Results written to results.txt\n");
    return 0;
}
```

---

# END
