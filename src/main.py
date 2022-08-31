from textx import metamodel_from_file
from pathlib import Path
import os
import sys

def store_identifiers(contract):
    #store all start identifiers
    for start_identifier in contract.startIdentifier:
        start_identifiers.append(start_identifier.strip())

    #store all identifiers in contract
    for code in contract.code:
        if hasattr(code, 'identifier'):
            for elem in code.identifier:
                if elem.strip() not in identifier_list:
                    identifier_list.append(elem.strip())

def check_identifiers():
    check = False
    for start_identifier in start_identifiers:
        if start_identifier in identifier_list:
            check = True

    if check == False:
        raise Exception('Start identifier/s not found in any of the annotation identifier/s')

# def generate_all_files():
#     for identifier in identifier_list:
#         file = open_file(identifier)
#         for code in contract.code:
#             if not hasattr(code, 'identifier'):
#                 file.write(code.replace('\n', '').rstrip().replace('\r', '') + '\n')
#                 continue
#             for elem in code.identifier:
#                 if identifier == elem.strip():
#                     for unique_code in code.uniqueCode:
#                         file.write(unique_code.rstrip().replace('\n', '').replace('\r', '') + '\n')
#         file.close()

def generate_files(list):
    for identifier in list:
        file = open_file(identifier)
        for code in contract.code:
            if not hasattr(code, 'identifier'):
                file.write(code.replace('\n', '').rstrip().replace('\r', '') + '\n')
                continue
            for elem in code.identifier:
                if identifier == elem.strip():
                    for unique_code in code.uniqueCode:
                        file.write(unique_code.rstrip().replace('\n', '').replace('\r', '') + '\n')
        file.close()

def open_file(identifier):
    if source_file_dir != '':
        p = source_file_dir + '\\' + 'Generated'
        if not Path(p).exists():
            os.makedirs(p)
        p = p + '\\' + source_file_name + '_' + identifier.replace(' ', '_') + '.sol'
    else:
        p = source_file_name + '_' + identifier.replace(' ', '_') + '.sol'
    try:
        if Path(p).exists():
            file = open(p, 'w')
        else:
            file = open(p, 'x')
        return file
    except:
        raise Exception('Identifier \'' + identifier + '\' contains one or more characters which are illegal in file names')

def main():
    #ensure proper cli usage
    if len(sys.argv) != 2:
        raise Exception('Invalid argument length. Usage: python main.py <path to source code>')
    
    #store all identifiers
    store_identifiers(contract)

    if 'ALL' in start_identifiers:
        #output file for each identifier
        generate_files(identifier_list)
    else:
        #check that at least one start identifier matches at least one identifier in contract
        check_identifiers()
        #output single file for only the specified annotations
        generate_files(start_identifiers)

#setting all neccessary paths
source_file_path = sys.argv[1]
source_file_name = os.path.basename(os.path.splitext(source_file_path)[0])
source_file_dir = os.path.dirname(source_file_path)
curr_path = os.path.dirname(__file__)
path_to_grammar = os.path.join(curr_path, 'textX', 'grammar.tx')

#initialize TextX metamodel and generate the contract model
grammar = metamodel_from_file(path_to_grammar)
contract = grammar.model_from_file(source_file_path)

#initialize empty lists to hold identifiers
start_identifiers = []
identifier_list = []

main()