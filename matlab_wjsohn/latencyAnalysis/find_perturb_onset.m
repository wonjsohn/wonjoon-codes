% detects first rising index

function ind = find_perturb_onset(input)

for i=1:length(input)
    if (input(i) < input(i+1))
        ind = i;
        break
    end
end
        
