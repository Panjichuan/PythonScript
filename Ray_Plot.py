# -*- coding: utf-8 -*-
"""
Spyder Editor
author：panjichuan
date：13 Dec
This is a Ray_Plot script file.
"""

#==============================================================================
# 引入需要的库和模块
#==============================================================================
import os
import xlrd
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
plt.style.use('ggplot')  # 绘图风格使用ggplot
#==============================================================================
# 读取坑透数据文件
#==============================================================================
root = input('请输入坑透设计数据文件存放的文件夹路径：')
filename = os.listdir(root)
path = os.path.join(root, filename[0])
if str.split(filename[0], '.')[1] != 'xlsx':
    print('该目录下不存在坑透设计数据文件，请重新选择其所在路径！')
print('文件路径是：%s' % path)
image_path = os.path.join(root, 'ray_plot.png')
data = xlrd.open_workbook(path)
#==============================================================================
# 获取发射点和接收点的坐标
#==============================================================================
rx_table = data.sheet_by_name(data.sheet_names()[0])  # 获取sheet1的内容-接收点
rx_data = []
rx_row_num = rx_table.nrows
for i in np.arange(rx_row_num):
    rx_data.append(rx_table.row_values(i))
rx_points = pd.DataFrame(rx_data[3:], columns=rx_data[2])
tx_table = data.sheet_by_name(data.sheet_names()[1])  # 获取sheet2的内容-发射点
tx_data = []
tx_num = tx_table.nrows
for j in np.arange(tx_num):
    tx_data.append(tx_table.row_values(j))
tx_points = pd.DataFrame(tx_data[1:], columns=tx_data[0])
#==============================================================================
# 坐标点位初始化
#==============================================================================
tx_A_coordinate = tx_points.loc[:, ['Ax', 'Ay']]
tx_B_coordinate = tx_points.loc[:, ['Bx', 'By']]
rx_A_coordinate = rx_points.loc[:, ['Ax', 'Ay']]
rx_B_coordinate = rx_points.loc[:, ['Bx', 'By']]
A_RecStart = tx_points['A_RecStart']
B_RecStart = tx_points['B_RecStart']
A_RecEnd = tx_points['A_RecEnd']
B_RecEnd = tx_points['B_RecEnd']
#==============================================================================
# 数据检查函数
#==============================================================================


def Clear_empty_characters(df):
    for i in np.arange(len(df)):
        if df.iloc[i, 1] == '':  # df.iloc[] DataFrame切片、定位方法
            df = df[df != ''].dropna()
            break
    return df


rx_A_coordinate = Clear_empty_characters(rx_A_coordinate)
rx_B_coordinate = Clear_empty_characters(rx_B_coordinate)
#==============================================================================
# 绘图
#==============================================================================
fig = plt.figure(figsize=(20, 5), dpi=100)
ax = fig.add_subplot(1, 1, 1)
# A面发射，B面接收
for i in np.arange(len(tx_A_coordinate['Ax'])):
    for j in np.arange(B_RecStart[i], B_RecEnd[i] + 1, 1):
        plt.plot([tx_A_coordinate['Ax'][i], rx_B_coordinate['Bx'][j]],
                 [tx_A_coordinate['Ay'][i], rx_B_coordinate['By'][j]],
                 c='k')
# B面发射，A面接收
for i in np.arange(len(tx_B_coordinate['Bx'])):
    for j in np.arange(A_RecStart[i], A_RecEnd[i] + 1, 1):
        plt.plot([tx_B_coordinate['Bx'][i], rx_A_coordinate['Ax'][j]],
                 [tx_B_coordinate['By'][i], rx_A_coordinate['Ay'][j]],
                 c='k')
# 点位图
plot1 = plt.scatter(rx_A_coordinate['Ax'], rx_A_coordinate['Ay'], c='c')
plot2 = plt.scatter(rx_B_coordinate['Bx'], rx_B_coordinate['By'], c='c')
plot3 = plt.scatter(tx_A_coordinate['Ax'], tx_A_coordinate['Ay'], c='r')
plot4 = plt.scatter(tx_B_coordinate['Bx'], tx_B_coordinate['By'], c='r')
# 坐标轴关闭，并设置标签
plt.axis('off')
plt.legend([plot1, plot3], ('Recieve Point', 'Emit Point'))
plt.show()
# 保存图像
choice = input('无线电波透视射线覆盖图已绘制完成，是否保存图像？  是（y）\否（n）:')
if choice == 'y':
    fig.savefig(image_path, bbox_inches='tight')
    print('图像保存完毕，请到相应文件目录下查看')
else:
    print('图像未保存，请考虑是否需要修改！')
