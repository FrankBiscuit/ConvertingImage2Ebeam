                                                                                                                                                                                                                                                     # -*- coding: utf-8 -*-
"""
Created on Wed Jul 31 17:49:26 2024

@author: 2704879w
"""

import scipy.io as scio

# Load the .mat file
mat_data = scio.loadmat('bayer_r.mat')
R_channel = mat_data['bayerImageR_Store']

mat_data = scio.loadmat('bayer_b.mat')
B_channel = mat_data['bayerImageB_Store']

mat_data = scio.loadmat('bayer_g.mat')
G_channel = mat_data['bayerImageG_Store']


# Assign Filters into position

import klayout.db as db
import math

ly = db.Layout()
top_cell = ly.create_cell("TOP")
spacingx = 2
spacingy = 2
input_files = [f"Red_20lvl_2um_{i}.gds" for i in range(1, 21)]
gds_map = R_channel
x_offset = 0
y_offset = 0
for row in range(600):
    for col in range(450):
        # X and Y offsets based on row, col, and spacing
        x_offset = col * spacingx
        y_offset = row * spacingy
        
        # Get the GDSII file corresponding to the matrix value
        
        level = gds_map[row,col]
        # print(f"Placing {file} at ({x_offset}, {y_offset})")
        if level>0:
            
            file = input_files[level-1]
            ly_import = db.Layout()
            ly_import.read(file)
            imported_top_cell = ly_import.top_cell()
            
            target_cell = ly.create_cell(imported_top_cell.name)
            target_cell.copy_tree(imported_top_cell)
            
            # Free the resources of the imported layout
            ly_import._destroy()
            
            # Place the imported cell at the correct position
            inst = db.DCellInstArray(target_cell.cell_index(), db.DTrans(db.DVector(x_offset, y_offset)))
            top_cell.insert(inst)
            print('r',row,col)
            
x_offset = 0
y_offset = 0

input_files = [f"Green_20lvl_2um_{i}.gds" for i in range(1, 21)]
gds_map = G_channel
x_offset = 0
y_offset = 0
for row in range(600):
    for col in range(450):
        # X and Y offsets based on row, col, and spacing
        x_offset = col * spacingx
        y_offset = row * spacingy
        
        # Get the GDSII file corresponding to the matrix value
        
        level = gds_map[row,col]
        # print(f"Placing {file} at ({x_offset}, {y_offset})")
        if level>0:
            
            file = input_files[level-1]
            ly_import = db.Layout()
            ly_import.read(file)
            imported_top_cell = ly_import.top_cell()
            
            target_cell = ly.create_cell(imported_top_cell.name)
            target_cell.copy_tree(imported_top_cell)
            
            # Free the resources of the imported layout
            ly_import._destroy()
            
            # Place the imported cell at the correct position
            inst = db.DCellInstArray(target_cell.cell_index(), db.DTrans(db.DVector(x_offset, y_offset)))
            top_cell.insert(inst)
            print('g',row,col)
            
input_files = [f"Blue_20lvl_2um_{i}.gds" for i in range(1, 21)]
gds_map = B_channel
x_offset = 0
y_offset = 0
for row in range(600):
    for col in range(450):
        # X and Y offsets based on row, col, and spacing
        x_offset = col * spacingx
        y_offset = row * spacingy
        
        # Get the GDSII file corresponding to the matrix value
        
        level = gds_map[row,col]
        # print(f"Placing {file} at ({x_offset}, {y_offset})")
        if level>0:
            
            file = input_files[level-1]
            ly_import = db.Layout()
            ly_import.read(file)
            imported_top_cell = ly_import.top_cell()
            
            target_cell = ly.create_cell(imported_top_cell.name)
            target_cell.copy_tree(imported_top_cell)
            
            # Free the resources of the imported layout
            ly_import._destroy()
            
            # Place the imported cell at the correct position
            inst = db.DCellInstArray(target_cell.cell_index(), db.DTrans(db.DVector(x_offset, y_offset)))
            top_cell.insert(inst)
            print('b',row,col)


            
            
filename = f"sunflower_2um_large.gds"
        
ly.write(filename)
            

        