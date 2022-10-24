import os
import sys
import re
import binascii

zero_operators = {
  "RST": "0000"
}

one_operators = {
  "MUL2": "0001",
  "DIV2": "0010",
  "CLR": "0011",
  "OUT": "0100"
}

two_operators = {
  "ADD": "0101",
  "SUB": "0110",
  "ADDi": "0111",
  "SUBi": "1000",
  "MOV": "1001"
}

mono_operators = {
  "JMP": "1010",
  "LOAD": "1011",
  "STORE": "1100"
}

def int_to_6_binary(number):
  return f'{int(number):06b}'

def int_to_3_binary(number):
  return f'{int(number):03b}'

def valid_zero_operation(line):
  return bool(re.match(r"^({0})$".format("|".join(zero_operators.keys())), line))

def valid_one_operation(line):
  return bool(re.match(r"^({0}) \d$".format("|".join(one_operators.keys())), line))

def valid_two_operation(line):
  return bool(re.match(r"^({0}) \d,\d$".format("|".join(two_operators.keys())), line))

def valid_mono_operation(line):
  return bool(re.match(r"^({0}) \d{{1,2}}$".format("|".join(mono_operators.keys())), line))

def parse_zero_operators(line):
  if valid_zero_operation(line) is False:
     raise Exception(f"invalid line {line}")

  binary = zero_operators[line.strip()] + int_to_6_binary("0".strip())

  binary_file.append(binary)

def parse_one_operators(line):
  if valid_one_operation(line) is False:
    raise Exception(f"invalid line {line}")

  [op, reg] = line.split(" ")

  binary = one_operators[op.strip().upper()] + int_to_3_binary(reg.strip()) + int_to_3_binary("0".strip())

  binary_file.append(binary)

def parse_two_operators(line):
  if valid_two_operation(line) is False:
    raise Exception(f"invalid line {line}")

  [op, regs] = line.split(" ")

  [reg1, reg2] = regs.split(",")

  binary = two_operators[op.strip().upper()] + int_to_3_binary(reg1.strip()) + int_to_3_binary(reg2.strip())

  binary_file.append(binary)

def parse_mono_operators(line):
  if valid_mono_operation(line) is False:
    raise Exception(f"invalid line {line}")

  [op, reg] = line.split(" ")

  binary = mono_operators[op.strip().upper()] + int_to_6_binary(reg.strip())

  binary_file.append(binary)

def parse_file(f): 
  if os.access(f, os.R_OK):
    with open(f) as fp:
      file = fp.read()

  file = file.split('\n')

  for line in file:
    line = line.split(';')
    line = line[0].strip()

    for operation in zero_operators.keys():
      if operation in line:
        parse_zero_operators(line)
    
    for operation in one_operators.keys():
      if operation in line:
        parse_one_operators(line)

    for operation in two_operators.keys():
      if operation in line:
        parse_two_operators(line)

    for operation in mono_operators.keys():
      if operation in line:
        parse_mono_operators(line)

def save_to_file(binary_file):
  text_file = open("./data.txt", "w")
  text_file.write('\n'.join(binary_file))
  text_file.close()

fileName = sys.argv[0]
path = os.path
binary_file = []

parse_file(fileName)
save_to_file(binary_file)