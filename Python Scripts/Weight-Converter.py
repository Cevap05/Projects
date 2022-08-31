# Put in your current weight.
# Select what you would like to convert to, and get the result!

w8 = int(input("What's your weight: "))
w8_type = input("Convert to (K)g or (L)bs?: ")

if w8_type == "K" or w8_type == "k":
    print("Weight in Kg: " + str(w8 / 2.2))
elif w8_type == "L" or w8_type == "l":
    print("Weight in Lb: " + str(w8 * 2.2))
