import re

def best_match(patterns, text):
    matches = []
    
    for label, pattern in patterns.items():
        # print(label, pattern)
        
        matched = re.match(pattern, text)

        if matched:
            matches.append((label, matched.group()))

    if matches:
        longest = max(matches, key=lambda m: len(m[1]))
        return longest

    return "None"

def tokenize(dict_regex, text, token_list):
    # token_stream = []
    text = text.strip()
    # print(text)

    if text != "":
        token = best_match(dict_regex, text)

        if token != "None":
            text = re.sub(token[1], "", text, count=1)
            token_list.append(token)

            return tokenize(dict_regex, text, token_list)

        else:
            print("Error, no match found")
            return token_list

    else:
        print("String ended")
        return token_list

dict_regex = {"int": r"^-?[0-9]+\b",
              "identifier": r"^[a-zA-Z]\w*\b",
              "op_asign": r"^=",
              "op_compare": r"^==",
              "op_substraction": r"^-"
              }


# text = "    \n\t abc123 == -78";
text = "     \t\na = 32.4 \n*(-8.6 - b) /   6.1E-8";
token_stream = []

print(tokenize(dict_regex, text, token_stream))