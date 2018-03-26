# -*- coding: utf-8 -*-
"""
Created on Mon Oct  9 09:34:04 2017

@author: PanJichuan
"""
#==============================================================================
# 读取文件路径、获取文件名称
#==============================================================================
import os
import numpy as np
root = input('请输入protem47数据文件的路径：')
filename = os.listdir(root)
path = os.path.join(root, filename[0])
if str.split(filename[0], '.')[1] != 'Gx7':
    print('该目录下不存在protem47数据文件，请重新选择其所在路径！')
print('文件路径是：%s' % path)
name = str.split(filename[0], '.')[0]
new_name = str(name) + '_modified.' + str.split(filename[0], '.')[1]
new_path = os.path.join(root, new_name)
#==============================================================================
# 读入文件流，存为虚拟文件
#==============================================================================
file = open(path, 'r')
lines = file.readlines()
file.close()
data_revised = []
data_inserted = []
data_final = []
#==============================================================================
# 检查日期格式是否是错误的
#==============================================================================
if ' ' in lines[2][:4]:
    str.replace(lines[2][:4], ' ', '0')
    print('文件中日期格式存在问题，已修改')
#==============================================================================
# 获取数据文件中的线号、点号、点号步长、起始数据记录号
#==============================================================================
line_No = int(lines[2][5:8])
if len(str(line_No)) == 1:
    str_line_No = '00' + str(line_No)
elif len(str(line_No)) == 2:
    str_line_No = '0' + str(line_No)
else:
    str_line_No = '00' + str(line_No)[0]
#获取起始点号
start_Point_No = int(lines[6][10:14])
if len(str(start_Point_No)) == 1:
    str_start_Point_No = '000' + str(start_Point_No)
elif len(str(start_Point_No)) == 2:
    str_start_Point_No = '00' + str(start_Point_No)
elif len(str(start_Point_No)) == 3:
    str_start_Point_No = '0' + str(start_Point_No)
else:
    str_start_Point_No = str(start_Point_No)
step_No = int(lines[2][10:14])
start_record_No = int(
    lines[6][str.find(lines[6], '#') + 1:str.find(lines[6], '#') + 6])
turns = 64  # 匝数
#==============================================================================
# 文件改写
#==============================================================================
i = 0
for elt1 in lines:
    #添加‘Space=W’
    if str.find(elt1, 'TEM58') > 0:
        data_revised.append(elt1[:28] + '  Space=W   ' + elt1[28:])
    #替换数据点信息
    elif str.find(elt1, 'RXA') > 0:
        data_revised.append(str.replace(str.replace(elt1, elt1[5:10], str_line_No + 'N '),
                                        elt1[10:16], str_start_Point_No + 'EH'))
    #添加一个Comment信息
    elif str.find(elt1, 'Comment') > 0:
        data_revised.append(elt1[:9] + ' LOOP' + '1' + '(%s,%s)' % (str(start_Point_No), str(line_No)[0]) +
                            '  ' + str(turns) + elt1[str.find(elt1, ':') + 4:])
    #替换数据点钟的点线号信息
    elif str.find(elt1, 'OPR REF') > 0:
        if (int(elt1[str.find(elt1, '#') + 1:str.find(elt1, '#') + 6]) - start_record_No) % 2 == 0:  # 余数运算
            #点号增加
            Point_No = start_Point_No + step_No * i
            if len(str(Point_No)) == 1:
                str_Point_No = '000' + str(Point_No)
                i = i + 1
            elif len(str(Point_No)) == 2:
                str_Point_No = '00' + str(Point_No)
                i = i + 1
            elif len(str(Point_No)) == 3:
                str_Point_No = '0' + str(Point_No)
                i = i + 1
            else:
                str_Point_No = str(Point_No)
                i = i + 1
        data_revised.append(str.replace(str.replace(
            elt1, elt1[5:10], str_line_No + 'N '), elt1[10:16], str_Point_No + 'EZ'))
    else:
        data_revised.append(elt1)
#==============================================================================
# 插入数据点的表头信息
#==============================================================================
elt_insert = data_revised[2:6]
lables = np.arange(9, len(data_revised), 4)
for elt2 in data_revised:
    if data_revised.index(elt2) in lables:
        data_inserted.append(elt2)
        data_inserted.extend(elt_insert)
        continue
    else:
        data_inserted.append(elt2)
del data_inserted[-10:]
#==============================================================================
# 修改数据点的表头信息
#==============================================================================
Point_No = start_Point_No
i = 1
for elt3 in data_inserted:
    if 'LOOP' in elt3:
        data_final.append(elt3[:14] + str(i) + '(%s,%s)' %
                          (str(Point_No), str(line_No)) + elt3[21:])
        Point_No = start_Point_No + step_No * i
        i = i + 1
    else:
        data_final.append(elt3)
data_final.append('XXXXXX\n')
#==============================================================================
# 写入新的文件
#==============================================================================
new_f = open(new_path, 'w')
for line in data_final:
    new_f.write(line)
new_f.close()
print('文件转化已完成，新的文件名为：%s' % new_name)
