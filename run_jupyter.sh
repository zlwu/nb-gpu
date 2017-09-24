#!/bin/bash

source activate py3 && jupyter notebook --no-browser --allow-root && source deactivate
