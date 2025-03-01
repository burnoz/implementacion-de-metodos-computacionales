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


def tokenize(dict_regex, text):
    token_stream = []

    while True:
        text = text.strip()
        
        if text != "":
            token = best_match(dict_regex, text)

            if token != "None":
                # print(token)
                text = text.replace(token[1], "", 1)
                token_stream.append(token)

            else:
                print("Error, no match found")
                return token_stream

        else:
            print("String ended")
            return token_stream


dict_regex = {"int": r"^-?[0-9]+\b",
              "identifier": r"^[a-zA-Z]\w*\b",
              "op_asign": r"^=",
              "op_compare": r"^==",
              "op_substraction": r"^-",
              "op_multiplication": r"^\*\b"
              }


text = "    \n\t abc123 == *78";

print(tokenize(dict_regex, text))

# pattern = r"^[a-zA-Z]\w*\b"  # expresion regular para identificadores
 
# text2 = "12aa123"
# match2 = re.match(pattern, text2)
# print(match2)
 
# text1 = "aa_123 otras cosas"
# match1 = re.match(pattern, text1)
# print(match1)
# print(match1.group())