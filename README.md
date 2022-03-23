# Graph Learning Based on Signal Smoothness Representation for Homogeneous and Heterogeneous Change Detection

This repository is a proposed approach based on Graph Signal processing for change detection under the folllowing name:

* Graph Learning Based on Signal Smoothness Representation for Homogeneous and Heterogeneous Change Detection in IEEE TGRS (currently under review).

## Datasets

--------------------Available datasets and Parameters---------------

   Dataset | Vx = Vy | K | Alpha |
   --------|:-------:|:-:|:-----:|
   Mulargia_dataset    |      11       |      1464     |   0.1     |
   Omodeo_dataset      |      20       |      174      |   0.109   |
   Alaska_dataset      |      11       |      1479     |   0.013   |
   Madeirinha_dataset  |      10       |      410      |   0.2     |
   Canada_dataset      |      44       |      2400     |   0.1     |
   Gloucester_1_dataset|      144      |      171      |   0.1     |
   Katios_dataset      |      23       |      102      |   0.738   |
   Atlantico_dataset   |      17       |      2029     |   0.103   |
   SF_dataset          |      16       |      260      |   0.215   |
   Wenchuan_dataset    |      8        |      1740     |   0.5     |
   Toulouse_dataset    |      86       |      192      |   0.002   |
   California_dataset  |      73       |      291      |   0.1     |
   Bastrop_dataset     |      23       |      393      |   0.1     |
   Gloucester_2_dataset|      150      |      444      |   0.042   |

These datasets are part of the following works:

* "[Graph-Based Data Fusion Applied to: Change Detection and Biomass Estimation in Rice Crops](https://www.mdpi.com/2072-4292/12/17/2683)" published in MDPI.

* Graph Learning Based on Signal Smoothness Representation for Homogeneous and Heterogeneous Change Detection in IEEE TGRS (currently under review).

Please if you use the datasets and the codes cite our work as:<br/>

@article{&nbsp;&nbsp;&nbsp;jimenez2020graph,<br/>
         &nbsp;&nbsp;&nbsp;title={Graph-Based Data Fusion Applied to: Change Detection and Biomass Estimation in Rice Crops},<br/>
         &nbsp;&nbsp;&nbsp;author={Jimenez-Sierra, David Alejandro and Ben{\'\i}tez-Restrepo, Hern{\'a}n Dar{\'\i}o and Vargas-Cardona, Hern{\'a}n Dar{\'\i}o and Chanussot, Jocelyn},<br/>
         &nbsp;&nbsp;&nbsp;journal={Remote Sensing},<br/>
         &nbsp;&nbsp;&nbsp;volume={12},<br/>
         &nbsp;&nbsp;&nbsp;number={17},<br/>
         &nbsp;&nbsp;&nbsp;pages={2683},<br/>
         &nbsp;&nbsp;&nbsp;year={2020},<br/>
         &nbsp;&nbsp;&nbsp;publisher={Multidisciplinary Digital Publishing Institute}<br/>
        }


## Requirements

In order to run the code, you will need to download and add to the path the following toolboxes:

* GMMSP [toolbox](https://github.com/ahban/GMMSP-superpixel) for superpixel segmentation 
* Graph signal processing [toolbox](https://epfl-lts2.github.io/gspbox-html) for graph smoothness prior. 
* Unlocbox [toolbox](https://github.com/epfl-lts2/unlocbox) for graph learning optimization.
