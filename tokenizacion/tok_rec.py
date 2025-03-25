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
        # print(longest)
        return longest

    return "None"

def tokenize(dict_regex, text, token_list):
    # token_stream = []
    text = text.strip()
    # print(text)

    if text != "":
        token = best_match(dict_regex, text)

        if token != "None":
            text = text.replace(token[1], "", 1)
            token_list.append(token)

            return tokenize(dict_regex, text, token_list)

        else:
            print("Error, no match found for ", text)
            return token_list, False

    else:
        # print("String ended")
        return token_list, True

dict_regex = {"for": r"^for\b",
            "if": r"^if\b",
            "else": r"^else\b",
            "print": r"^print\b",
            "with": r"^with\b",
            "open": r"^open\b",
            "in": r"^in\b",
            "while": r"^while\b",
            "def": r"^def\b",
            "return": r"^return\b",
            "as": r"^as\b",
            "not": r"^not\b",
            "import": r"^import\b",
            "enumerate": r"^enumerate\b",
            "method": r"^\.[a-zA-Z]\w*\b",
            "int": r"^-?[0-9]+\b",
            "float": r"^-?[0-9]+\.[0-9]+\b",
            "string": r"^\"(\\.|[^\"])*\"",
            "real_num": r"^-?[0-9]+\.[0-9]+E?-?[0-9]+\b",
            "identifier": r"^[a-zA-Z]\w*\b",
            "comment": r"^//.*",
            "python_comment": r"^#.*",
            "op_assign": r"^=",
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
            "open_parenthesis": r"^\(",
            "close_parenthesis": r"^\)",
            "open_bracket": r"^\[",
            "close_bracket": r"^\]",
            "open_brace": r"^{",
            "close_brace": r"^}",
            "colon": r"^:",
            "comma": r"^,",
            }

test_file = open("test.txt", "r")
lines = test_file.readlines()
line_num = 1
error_lines = []

for line in lines:
    token_list = []

    if line.strip():
        result = tokenize(dict_regex, line, token_list)

        print(f"Line {line_num}: {line.strip()}")
        print(result[0], "\n")

        if not result[1]:
            error_lines.append(line_num)
        
    line_num += 1

print("Errors found in lines: ")
for line in error_lines:
    print(line)