# Input the first number, second number, and the operator.
# Obtain result!

# Function that checks if input is numeric.
def num_checker(number):
    if not number.isnumeric():
        print("You must put in a number...")
        exit()
    else:
        return int(number)

# Obtains 1st & 2nd number & runs them through num_checker.
n1 = num_checker(input("What's the first number?: "))
n2 = num_checker(input("What's the second number?: "))

# Obtains the operator.
op = input("What operator would you like to use?: ")

# Takes numbers & operator, then gives the result.
if op == "+":
    print("Answer is: " + str(n1 + n2))
elif op == "-":
    print("Answer is: " + str(n1 - n2))
elif op == "*":
    print("Answer is: " + str(n1 * n2))
elif op == "/":
    print("Answer is: " + str(n1 / n2))
elif op == "**":
    print("Answer is: " + str(n1 ** n2))
else:
    print("Select an operator of +, -, *, and /.")
