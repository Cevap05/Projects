new_list = input('Enter elements of a list separated by space ')
split_list = new_list.split()

# Prints the split up list:
print('Split list loos like: ', split_list)

# Goes through each object in the list to convert each item to int type.
for i in range(len(split_list)):
    # Converts each item to int type.
    split_list[i] = int(split_list[i])
    print((split_list[i]))

# Calculating the sum of list elements
print("Sum = ", sum(split_list))