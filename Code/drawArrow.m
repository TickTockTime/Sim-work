function drawArrow(start_point, end_poiont,  arrow_color, line_color, arrow_size, line_width)
    % 判断参数数目，进行自动补充
    switch nargin
        case 2
            arrow_color = 'r';
            line_color = 'b';
            arrow_size = 2;
            line_width = 1;
        case 3
            line_color = 'b';
            arrow_size = 2;
            line_width = 1;
        case 4
            arrow_size = 2;
            line_width = 1;
        case 5
            line_width = 1;
    end
    dy = arrow_size*cos(pi/40*19);
    dx = arrow_size*sin(pi/40*19);
    plot([start_point, start_point], [0, end_poiont-dy],line_color,'lineWidth',line_width);
    hold on

    % 三角箭头(填充)
    triangle_x= [start_point, start_point+dx, start_point-dx, start_point];
    triangle_y= [end_poiont, end_poiont-dy, end_poiont-dy, end_poiont];
    h = fill(triangle_x,triangle_y, arrow_color);
    set(h,'edgecolor',arrow_color);
    hold on;

end