from textx import metamodel_from_file
from pathlib import Path
import os

curr_path = os.path.dirname(__file__)
path_to_grammar = os.path.join(curr_path, 'textX', 'grammar.tx')
path_to_contract = os.path.join(curr_path, '..', 'resources', 'Test Contract.sol')
grammar = metamodel_from_file(path_to_grammar)
contract = grammar.model_from_file(path_to_contract)

start_identifier = contract.startIdentifier.strip()
identifier_list = []

#store all identifiers in contract
for code in contract.code:
    if hasattr(code, 'identifier'):
        identifier_list.append(code.identifier.strip())

#check that start identifier matches at least one identifier in contract
if start_identifier not in identifier_list:
    raise Exception('Start identifier not found in any of the annotations')

#print whole contract with all unique code blocks
for code in contract.code:
    if hasattr(code, 'identifier'):
        for unique_code in code.uniqueCode:
            print(unique_code)
    else:
        print(code)

#print whole contract with one specific annotation 
for code in contract.code:
    if hasattr(code, 'identifier'):
        if start_identifier == code.identifier.strip():
            for unique_code in code.uniqueCode:
                print(unique_code)
    else:
        print(code)
