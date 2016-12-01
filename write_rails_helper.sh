for i in $( ls spec/features/*_spec.rb ); do
	echo "require 'rails_helper'" >> temp.txt
	tail -n +2 "$i" >> temp.txt
	mv temp.txt $i
done

for i in $( ls spec/models/*_spec.rb ); do
	echo "require 'rails_helper'" >> temp.txt
	tail -n +2 "$i" >> temp.txt
	mv temp.txt $i
done
