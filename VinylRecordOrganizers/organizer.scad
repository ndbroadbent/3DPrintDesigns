$fn = $preview ? 15 : 100;
EPSILON = 0.01;

BORDER_RADIUS = 8;
FULL_WIDTH = 255;
PLATE_THICKNESS = 2;
TAB_HEIGHT = 64;
TAB_WIDTH = 60;
FONT_SIZE = 30;

letter = "A";
level = 1;

module draw_letter(letter) {
  linear_extrude(height = PLATE_THICKNESS + EPSILON)
      text(text = letter, font = "Lintsec:style=Regular", size = FONT_SIZE,
           halign = "center", valign = "center");
}

difference() {
  union() {
    translate([ 0, 0, 0 ])
        hull() for (x = [ BORDER_RADIUS, FULL_WIDTH - BORDER_RADIUS ]) {
      for (y = [ BORDER_RADIUS, TAB_HEIGHT * level - BORDER_RADIUS ]) {
        translate([ x, y, 0 ]) cylinder(h = PLATE_THICKNESS, r = BORDER_RADIUS);
      }
    }
  }

  // translate(
  //     [ TAB_WIDTH - BORDER_RADIUS, TAB_HEIGHT + BORDER_RADIUS, -EPSILON /
  //     ]) cylinder(h = PLATE_THICKNESS + EPSILON, r = BORDER_RADIUS);

  translate([
    TAB_WIDTH / 2, TAB_HEIGHT / 2 * 0.96 + (TAB_HEIGHT * (level - 1)),
    -EPSILON / 2
  ]) draw_letter(letter);
  translate([
    FULL_WIDTH - (TAB_WIDTH / 2),
    TAB_HEIGHT / 2 * 0.96 + (TAB_HEIGHT * (level - 1)), -EPSILON / 2
  ]) mirror([ 1, 0, 0 ]) draw_letter(letter);

  // translate([ TAB_WIDTH, TAB_HEIGHT, -EPSILON / 2 ])
  //     hull() for (x = [
  //                   BORDER_RADIUS, FULL_WIDTH - BORDER_RADIUS - TAB_WIDTH * 2
  //                 ]) {
  //   for (y = [ BORDER_RADIUS, TAB_HEIGHT * (level - 1) + BORDER_RADIUS ]) {
  //     translate([ x, y, 0 ])
  //         cylinder(h = PLATE_THICKNESS + EPSILON, r = BORDER_RADIUS);
  //   }
  // }
}
