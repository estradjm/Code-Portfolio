function [sol, h] = stack(sol,~)

global OBJECT_LIST
global STRIP_WIDTH

% This function takes an element from the population and
% returns its height after packing
%
% sol = element of population
% h = height after packing

% Preallocates total_area and n
%
% total_area = total area the objects take up
% n = how many objects
n = size(OBJECT_LIST);
n = n(1);

% Preallocates list
%
% list = given list of objects (after translating from genotype)

list = zeros(n,2);

% compute list
for i = 2:2:2*n %We index like this to check if the object needs to be rotated
    if sol(i) == 0 %This means the object is not rotated
        list(i/2,:) = OBJECT_LIST(sol(i-1),:);
    else %This means that the object is to be rotated
        list(i/2,:) = [OBJECT_LIST(sol(i-1),2) OBJECT_LIST(sol(i-1),1)];
    end
end

% Preallocates dlist, i, j, k, l, m
%
% dlist = keeps track of the heights and widths of the objects as they are
% being stacked. For example, if have has stack an object of width 3 with height 2
% into a strip of width 6, dlist will look this this:
% dlist = [2 2 2 0 0 0]
%
% i = current position in list, i.e. the object to be stack
% j = The current position of the where the left edge of the
% next object to be place
% k = Total width of objects placed in current tower 
% l = The furthest location as to 
% m = Current minimum height of objects placed.
dlist = zeros(1,STRIP_WIDTH);
i = 1;
j = 1;
k = list(1); %Width of the first object to be placed
l = 0;
m = 0;

% Intial Placement
while (k < STRIP_WIDTH) && (i <= n)
    dlist(j:j+list(i)-1) = list(i,2); %Updates dlist
    j = j+list(i); %Updates j
	i = i+1; %Updates i
    k = k + list(i); %Updates k
end
%This loop will place as many objects as possible on the base level of the strip

% Finds the current max of the list
h = max(dlist);

% Preallocates clist 
%
% clist = a dlist which we can change (without messing up the original dlist)
clist = dlist;

while i <= n
    h = max(dlist); %Updates h
    
    [m j] = min(clist); %Finds the position of the tower with the minimum height
    
    %We now check to see if the minimum is the same as the maximum
    if m ~= h %We enter this if statement if the minimum is different than the max
        l = j; %Sets l equal to j
        while (l < STRIP_WIDTH) && (clist(l+1) == clist(j))
            %Note that we enter this loop if and only if there is more than one
            %unit of space that can be packed.
            l = l + 1; %Increases the size of l by one
        end
    
        %We now check if we can place any objects in the space that has length l - j + 1
        if list(i) > l - j + 1
            %We enter this if statement if there is no room
            clist(j:l) = clist(j:l) + 1; 
            %We increment by one to generate a new minimum or possibly the same one...
        else
            %We enter this statement if the current object can be placed
            k = list(i); %Set k equal to the width of the current object
            while (k <= l - j + 1)
                %We enter this while loop provided that there is still room to place objects
                dlist(j:j+list(i)-1) = clist(j:j+list(i)-1) + list(i,2); %Update dlist
                if i < n
                    %We only enter if statement if there are still objects to pack
                    j = j+list(i); %Update j
                    i = i+1; %Update i
                    k = list(i); %Update k
                else
                    %We enter this else statement if there are no more objects to pack
                    i = i+1;
                    break
                end
            end
        	clist = dlist; %Update clist with the new dlist
        end
    else 
        %Note that we enter this section if and only if there is no room between 
        %the objects that have been stacked to squeeze the current object, i.e. we have to
        %start at the left edge of the strip at the height of the highest point in the
        %current stacking
        k = list(i);
        while (k < STRIP_WIDTH) && (i <= n)
            dlist(j:j+list(i)-1) = clist(j:j+list(i)-1) + list(i,2);
            j = j+list(i);
            i = i+1;
            k = k + list(i);
        end
        %This while loop is exactly the same as the initial packing.
        clist = dlist; %Update clist with the new dlist
    end
end

% The maximum height of the objects after they have been stacked
h = max(dlist);