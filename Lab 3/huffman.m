bits = 4;
p0 = 0.75;

p1 = 1 - p0;
symbols = 1:2^bits;

switch bits
    case 3
        p = [p0^3 p0^2*p1 p0^2*p1 p0*p1^2 p0^2*p1 p0*p1^2 p0*p1^2 p1^3];
    case 4
        p = [p0^4 p0^3*p1 p0^3*p1 p0^2*p1^2 p0^3*p1 p0^2*p1^2 p0^2*p1^2 p0*p1^3 p0^3*p1 p0^2*p1^2 p0^2*p1^2 p0*p1^3 p0^2*p1^2 p0*p1^3 p0*p1^3 p1^4];
end

[dict, avglen] = huffmandict(symbols, p);
disp("Average Length: " + avglen);
dict(:, 2) = cellfun(@num2str, dict(:, 2), 'UniformOutput', false);
disp(dict);



