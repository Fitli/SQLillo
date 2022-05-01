for w in 0..8 {
    memory = actualise_pos(w, map, memory);
    if is_stuck(w, memory) {
        info(`Ivana: ${w} random`);
        random(w);
    }
    else if w % 3 == 0 {
        info(`Ivana: ${w} moment`);
        memory = momented(w, map, memory);
    }
    else {
        info(`Ivana: ${w} normal`);
        normal(w, map);
    }
    info(`Ivana: ${w} executed`);
}

fn normal(w, map) {
    let x = worker(w).x;
    let y = worker(w).y;
    let r = 0;
    
    random(w);
    info("after_calling_random");
    
    r = (rand() % 10).abs();
    if r>0 {
        info("enters condition");
        for i in 0..20 {
            r = (rand() % 4).abs();
            if r == 0 && x > 0 && map[x-1][y] != worker(w).color {
                worker(w).move_left();
            }
            if r == 1 && x < 39 && map[x+1][y] != worker(w).color {
                worker(w).move_right();
            }
            if r == 2 && y > 0 && map[x][y-1] != worker(w).color {
                worker(w).move_down();
            }
            if r == 3 && y < 39 && map[x][y+1] != worker(w).color {
                worker(w).move_up();
            }
        }
        info("20 tries");
        for i in 0..20 {
            r = (rand() % 4).abs();
            if r == 0 && x > 0 && map[x-1][y] != worker(w).color && map[x-1][y] != Tile::EMPTY{
                worker(w).move_left();
            }
            if r == 1 && x < 39 && map[x+1][y] != worker(w).color && map[x+1][y] != Tile::EMPTY {
                worker(w).move_right();
            }
            if r == 2 && y > 0 && map[x][y-1] != worker(w).color && map[x][y-1] != Tile::EMPTY {
                worker(w).move_down();
            }
            if r == 3 && y < 39 && map[x][y+1] != worker(w).color && map[x][y+1] != Tile::EMPTY {
                worker(w).move_up();
            }
        }
        info("40 tries");
        if (x==0 || map[x-1][y]==worker(w).color) && 
           (x==39 || map[x+1][y]==worker(w).color) && 
           (x==0 || map[x][y-1]==worker(w).color) && 
           (x==39 || map[x][y+1]==worker(w).color)
        {
            info("closes condition");
            closest_exit(w, x, y, map);
        }
    }
    info("normal finished condition");
}

fn momented(w, map, memory) {
    if (`dir${w}` in memory) == false {
        memory[`dir${w}`] = 0;
    }
    
    let x = worker(w).x;
    let y = worker(w).y;
    if (x==0 || map[x-1][y]==worker(w).color) && 
           (x==39 || map[x+1][y]==worker(w).color) && 
           (x==0 || map[x][y-1]==worker(w).color) && 
           (x==39 || map[x][y+1]==worker(w).color)
    {
        memory[`dir${w}`] = closest_exit(w, x, y, map);
        return memory;
    }
    
    let r = (rand() % 30).abs();
    if(r == 0) {
        change_dir(memory[`dir${w}`]);
    }
    
    let nextx = next_x(x, y, memory[`dir${w}`]);
    let nexty = next_y(x, y, memory[`dir${w}`]);
    
    while nextx < 0 || nexty < 0 || nextx>39 || nexty > 39 {
        memory[`dir${w}`] = change_dir(memory[`dir${w}`]);
        nextx = next_x(x, y, memory[`dir${w}`]);
        nexty = next_y(x, y, memory[`dir${w}`]);
    }

    if memory[`dir${w}`] == 0 || (memory[`dir${w}`] == 4 && (x+y)%2 == 0) || (memory[`dir${w}`] == 7 && (x+y)%2 == 1) {
        worker(w).move_up();
    }
    if memory[`dir${w}`] == 1 || (memory[`dir${w}`] == 5 && (x+y)%2 == 0) || (memory[`dir${w}`] == 4 && (x+y)%2 == 1) {
        worker(w).move_right();
    }
    if memory[`dir${w}`] == 2 || (memory[`dir${w}`] == 6 && (x+y)%2 == 0) || (memory[`dir${w}`] == 5 && (x+y)%2 == 1) {
        worker(w).move_down();
    }
    if memory[`dir${w}`] == 3 || (memory[`dir${w}`] == 7 && (x+y)%2 == 0) || (memory[`dir${w}`] == 6 && (x+y)%2 == 1) {
        worker(w).move_left();
    }
    return memory;
}

fn random(w) {
    let x = worker(w).x;
    let y = worker(w).y;
    let r = 0;
    
    for i in 0..20 {
        r = (rand() % 4).abs();
        if r == 0 && x > 0 {
              worker(w).move_left();
        }
        if r == 1 && x < 39 {
              worker(w).move_right();
        }
        if r == 2 && y > 0 {
              worker(w).move_down();
        }
        if r == 3 && y < 39 {
              worker(w).move_up();
        }
    }
}

fn change_dir(dir) {
    let r = (rand() % 2).abs();
    if r == 0 {
        dir -=1;
        if (dir < 0) {
            dir = 7;
        }
    }
    if r == 1 {
        dir +=1;
        if (dir > 7) {
            dir = 0;
        }
    }
    return dir;
}

fn next_x(x, y, dir) {
    if(dir == 1 || (dir == 5 && (x+y)%2 == 0) || (dir == 4 && (x+y)%2 == 1)) {
        return x+1;
    }
    if(dir == 3 || (dir == 7 && (x+y)%2 == 0) || (dir == 6 && (x+y)%2 == 1)) {
        return x-1;
    }
    return x;
}

fn next_y(x, y, dir) {
    if(dir == 0 || (dir == 4 && (x+y)%2 == 0) || (dir == 7 && (x+y)%2 == 1)) {
        return y+1;
    }
    if(dir == 2 || (dir == 6 && (x+y)%2 == 0) || (dir == 5 && (x+y)%2 == 1)) {
        return y-1;
    }
    return y;
}

fn closest_exit(w, x, y, map) {
    worker(w).move_up();
    let dist_right = 0;
    while x+dist_right < 40 && map[x+dist_right][y] == worker(w).color {
        dist_right += 1;
    }
    if(x+dist_right > 39) {
        dist_right = 100;
    }
    
    let dist_left = 0;
    while x-dist_left >= 0 && map[x-dist_left][y] == worker(w).color {
        dist_left += 1;
    }
    if(x-dist_left < 0) {
        dist_left = 100;
    }
    
    let dist_up = 0;
    while y+dist_up < 40 && map[x][y+dist_up] == worker(w).color {
        dist_up += 1;
    }
    if(y+dist_up > 39) {
        dist_up = 100;
    }
    
    let dist_down = 0;
    while y-dist_down >=0 && map[x][y-dist_down] == worker(w).color {
        dist_down += 1;
    }
    if(y-dist_down < 0) {
        dist_down = 100;
    }
    
    if dist_right <= dist_left && dist_right <= dist_down && dist_right <= dist_up {
        worker(w).move_right();
        return 1;
    }
    if dist_left <= dist_right && dist_left <= dist_down && dist_left <= dist_up {
        worker(w).move_left();
        return 3;
    }
    if dist_down <= dist_left && dist_down <= dist_right && dist_down <= dist_up {
        worker(w).move_down();
        return 2;
    }
    if dist_up <= dist_left && dist_up <= dist_down && dist_up <= dist_right {
        worker(w).move_up();
        return 0;
    }
}

fn actualise_pos(w, map, memory) {
    if (`act_x${w}` in memory) == false {
        memory[`act_x${w}`] = -1;
        memory[`act_y${w}`] = -1;
    }
    memory[`last_x${w}`] = memory[`act_x${w}`];
    memory[`last_y${w}`] = memory[`act_y${w}`];
    memory[`act_x${w}`] = worker(w).x;
    memory[`act_y${w}`] = worker(w).y;
    
    return memory;
}

fn is_stuck(w, memory) {
    return memory[`last_x${w}`] == memory[`act_x${w}`] && memory[`last_y${w}`] == memory[`act_y${w}`];
}
