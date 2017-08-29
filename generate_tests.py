import random
problems = ["1", "2", "3", "4"]
sub_problems = ["a", "b", "c"]
tests = ["1", "2", "3"]
responses = ["0", "1", "2"]

def format_char(c:str) -> str:
    return "\"%s\"" %(c)

def format_entry(p:str, s_p:str, t:str, r:str) -> str:
    return "(%s, %s, %s, \"%s\")" %(
            format_char(p), format_char(s_p), format_char(t),
            r)

print("[" + ",".join([format_entry(random.choice(problems),
                                    random.choice(sub_problems),
                                    random.choice(tests),
                                    random.choice(responses)) for i in range(20)]) + "]")
