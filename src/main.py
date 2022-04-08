from textx import metamodel_from_file
from pathlib import Path
import os

curr_path = os.path.dirname(__file__)
source_file_name = 'Test Contract'
path_to_grammar = os.path.join(curr_path, 'textX', 'grammar.tx')
path_to_resources = os.path.join(curr_path, '..', 'resources')
path_to_contract = os.path.join(path_to_resources, source_file_name + '.sol')

grammar = metamodel_from_file(path_to_grammar)
contract = grammar.model_from_file(path_to_contract)

start_identifiers = []
identifier_list = []

def store_identifiers(contract):
    #store all start identifiers
    for start_identifier in contract.startIdentifier:
        start_identifiers.append(start_identifier.strip())

    #store all identifiers in contract
    for code in contract.code:
        if hasattr(code, 'identifier'):
            identifier_list.append(code.identifier.strip())

def check_identifiers():
    check = False
    for start_identifier in start_identifiers:
        if start_identifier in identifier_list:
            check = True

    if check == False:
        raise Exception('Start identifier/s not found in any of the annotation identifier/s')

def generate_all_files():
    for identifier in identifier_list:
        file = open_file(identifier)
        for code in contract.code:
            if hasattr(code, 'identifier'):
                if identifier == code.identifier.strip():
                    for unique_code in code.uniqueCode:
                        file.write(unique_code.rstrip().replace('\n', '').replace('\r', '') + '\n')
            else:
                file.write(code.replace('\n', '').rstrip().replace('\r', '') + '\n')
        file.close()

def generate_file():
    #output single file for only the specified annotations
    for identifier in start_identifiers:
        file = open_file(identifier)
        for code in contract.code:
            if hasattr(code, 'identifier'):
                if identifier == code.identifier.strip():
                    for unique_code in code.uniqueCode:
                        file.write(unique_code.rstrip().replace('\n', '').replace('\r', '') + '\n')
            else:
                file.write(code.replace('\n', '').rstrip().replace('\r', '') + '\n')
        file.close()

def open_file(identifier):
    p = path_to_resources + '\\' + source_file_name + '_' + identifier.replace(' ', '_') + '.sol'
    try:
        if Path(p).exists():
            file = open(p, 'w')
        else:
            file = open(p, 'x')
        return file
    except:
        raise Exception('Identifier \'' + identifier + '\' contains one or more characters which are illegal in file names')

#store all identifiers
store_identifiers(contract)

if 'ALL' in start_identifiers:
    #output file for each identifier
    generate_all_files()
else:
    #check that at least one start identifier matches at least one identifier in contract
    check_identifiers()
    #output single file for only the specified annotations
    generate_file()