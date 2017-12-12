function[pop] = init(num,num_objects)

%This function generates an initial population of size 'num' from the given
%set of objects
%
%pop = inital population
%num = size of population
%num_objects = total number of objects avaliable

%Make pop the right size
pop = zeros(num,2*num_objects);

%Preallocates the variables s and n
s = linspace(1,num_objects,num_objects);
n = 0;

%Fill in pop
for i = 1:num
    for j = 1:2*num_objects
        if mod(j,2) == 1
            n = floor(length(s)*rand(1) + 1);
            pop(i,j) = s(n);
            if length(s) > 1
                s(n) = [];
            end
            %This will take from our list s = 1 2 ... num_objects and
            %randomly pick one of them. Then it puts this value into pop.
            %Then it removes it from s (if s has 2 or more elements)
            %and repeats the process.
        else
            pop(i,j) = floor(2*rand(1));
            %This generates either  '0' (if the random number plus .5 is
            %less than 1) or a '1' (if the random number plus .5 is more
            %than 1). This corresponds to a rotation of the object
        end
    end
    s = linspace(1,num_objects,num_objects);
    %Regenerates s to be used again.
end