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
            "float": r"^-?[0-9]+\.[0-9]+\b",
            "string": r"^\"\w*\"",
            "real_num": r"^-?[0-9]+\.[0-9]E?-?[0-9]+\b",
            "identifier": r"^[a-zA-Z]\w*\b",
            "comment": r"^//.*",
            "op_asign": r"^=",
            "op_compare": r"^==",
            "op_less": r"^<",
            "op_greater": r"^>",
            "op_less_eq": r"^<=",
            "op_greater_eq": r"^>=",
            "op_not_eq": r"^!=",
            "op_substraction": r"^-",
            "op_sum": r"^\+",
            "op_multiplication": r"^\*",
            "op_division": r"^/",
            "op_exp": r"^\^",
            "for": r"^for\b",
            "if": r"^if\b",
            "else": r"^else\b",
            "while": r"^while\b",
            "def": r"^def\b",
            "return": r"^return\b",
            "open_parenthesis": r"^\(",
            "close_parenthesis": r"^\)",
            "open_bracket": r"^\[",
            "close_bracket": r"^\]",
            "open_brace": r"^{",
            "close_brace": r"^}",
            }

# text = "    \n\t abc123 == -78";
text = " *";
token_stream = []

print(tokenize(dict_regex, text, token_stream))