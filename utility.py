def TimeConv(time, unit):
    if unit == "ms":
        time = time * 1e-3
    elif unit == "us":
        time = time * 1e-6
    elif unit == "ns":
        time = time * 1e-9
    elif unit == "ps":
        time = time * 1e-12
    return time
