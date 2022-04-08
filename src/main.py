from textx import metamodel_from_file
from pathlib import Path
import os

check = False

curr_path = os.path.dirname(__file__)
path_to_grammar = os.path.join(curr_path, 'textX', 'grammar.tx')
path_to_contract = os.path.join(curr_path, '..', 'resources', 'Test Contract.sol')
grammar = metamodel_from_file(path_to_grammar)
contract = grammar.model_from_file(path_to_contract)

start_identifiers = []
identifier_list = []

#store all start identifiers
for start_identifier in contract.startIdentifier:
    start_identifiers.append(start_identifier.strip())

#store all identifiers in contract
for code in contract.code:
    if hasattr(code, 'identifier'):
        identifier_list.append(code.identifier.strip())

#check that at least one start identifier matches at least one identifier in contract
for start_identifier in start_identifiers:
    if start_identifier in identifier_list:
        check = True

if check == False:
    raise Exception('Start identifier/s not found in any of the annotation identifier/s')

#print whole contract with all unique code blocks
if 'ALL' in start_identifiers:
    for code in contract.code:
        if hasattr(code, 'identifier'):
            for unique_code in code.uniqueCode:
                print(unique_code.rstrip().replace('\n', ''))
        else:
            print(code.replace('\n', ''))
else:
    #print whole contract with one specific annotation 
    for code in contract.code:
        if hasattr(code, 'identifier'):
            if code.identifier.strip() in start_identifiers:
                for unique_code in code.uniqueCode:
                    print(unique_code.rstrip().replace('\n', ''))
        else:
            print(code.replace('\n', ''))
