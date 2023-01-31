
# Generate list of all unique expressions, format combinations from success.log
# (The taco website expressions that were entered successfully)
ufname=unique_formats.log
echo "Generating set of unique expression and formats from the taco website and storing them in $ufname"
rm $ufname
touch $ufname
python process_expr.py --clean --unique --uformat >> $ufname

# Create the file that will contain all of the primitive data for SAM
# Evaluation Table 1
fname=tab2.log
echo "Table 2: generating $fname which reproduces Table 2 on page 10"
rm $fname
touch $fname

echo "Getting Table 2 data"

# lvlscan only compressed removed
echo "lvlscan, compressed, unique (Row 2, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive lvlscan --dense >> $fname
echo "lvlscan, compressed, non-unique (Row 2, Col All):" >> $fname
python process_expr.py --clean --primitive lvlscan --dense >> $fname

# lvlscan compressed and uncompressed removed
echo "lvlscan, comp. + uncomp., unique (Row 1, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive lvlscan >> $fname
echo "lvlscan, comp. + uncomp., non-unique (Row 1, Col All):" >> $fname
python process_expr.py --clean --primitive lvlscan >> $fname

# repeat removed
echo "repeat, unique (Row 3, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive repeat >> $fname
echo "repeat, non-unique (Row 3, Col All):" >> $fname
python process_expr.py --clean --primitive repeat >> $fname

# union removed
echo "union, unique (Row 4, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive union >> $fname
echo "union, non-unique (Row 4, Col All):" >> $fname
python process_expr.py --clean --primitive union >> $fname

# inter removed but keep locate
echo "inter, keep locator, unique (Row 5, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive inter >> $fname
echo "inter, keep locator, non-unique (Row 5, Col All):" >> $fname
python process_expr.py --clean --primitive inter >> $fname

# inter removed and locate removed
echo "inter, locator removed, unique (Row 6, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive inter --dense >> $fname
echo "inter, locator removed, non-unique (Row 6, Col All):" >> $fname
python process_expr.py --clean --primitive inter --dense >> $fname

# add removed
echo "add, unique (Row 7, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive add >> $fname
echo "add, non-unique (Row 7, Col All):" >> $fname
python process_expr.py --clean --primitive add >> $fname

# mul removed
echo "mul, unique (Row 8, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive mul >> $fname
echo "mul, non-unique (Row 8, Col All):" >> $fname
python process_expr.py --clean --primitive mul >> $fname

# reduce removed
echo "reduce, unique (Row 9, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive reduce >> $fname
echo "reduce, non-unique (Row 9, Col All):" >> $fname
python process_expr.py --clean --primitive reduce >> $fname

# crddrop removed
echo "crddrop, unique (Row 10, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive crddrop >> $fname
echo "crddrop, non-unique (Row 10, Col All):" >> $fname
python process_expr.py --clean --primitive crddrop >> $fname

# lvlwr only compressed removed
echo "lvlwr, compressed, unique (Row 11, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive lvlwr --dense >> $fname
echo "lvlwr, compressed, non-unique (Row 11, Col All):" >> $fname
python process_expr.py --clean --primitive lvlwr --dense >> $fname

# lvlwr compressed and uncompressed removed
echo "lvlwr, comp. + uncomp., unique (Row 12, Col Unique):" >> $fname
python process_expr.py --filename $ufname --primitive lvlwr >> $fname
echo "lvlwr, comp. + uncomp., non-unique (Row 12, Col All):" >> $fname
python process_expr.py --clean --primitive lvlwr >> $fname
