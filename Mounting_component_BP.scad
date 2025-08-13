

// ===== Parameters =====
main_w            = 22;           // Width of main housing
main_l            = 36;           // Length of main housing
main_h            = 10;           // Height of main housing
wall              = 1;            // Shell wall thickness
fn                = 64;           // Resolution for cylinders

// Derived inner dimensions
inner_w           = main_w - 2*wall;
inner_l           = main_l - 2*wall;
inner_h           = main_h - wall;

// Cylinder dimensions and offsets
outer_cyl1_d      = main_w;
inner_cyl1_d      = main_w - 2*wall;
outer_cyl2_d      = 32;
inner_cyl2_d      = outer_cyl2_d - 2*wall;
cyl_h_outer       = main_h;
cyl_h_inner       = inner_h;
cyl1_offset       = 18;
cyl2_offset       = -26.8;

// Shell Z-offset
shell_z_offset    = -wall/2;     // e.g., -0.5

// Slot parameters
slot_size         = [40, 10, 3]; // [X, Y, Z]
slot_rot_angle    = 90;
slot_z_offset     = 1.5;
slot_trans1       = [-45, -13];
slot_trans2       = [0, -43];

// Adapter parameters
adapter_outer_d   = 8;
adapter_wall      = 1.5;
adapter_inner_d   = adapter_outer_d - 2*adapter_wall;
adapter_h_outer  = 10;
adapter_cap_h     = 1;
adapter_cap_d     = 6;

// Text parameters
text_font         = "Arial:style=Bold";
text_translate    = [0, -7, 10];
text_rot_angle    = -90;

// ===== Main Model =====
difference() {
    // Main housing exterior
    union() {
        cube(size = [main_w, main_l, main_h], center = true);
        translate([0, cyl1_offset, 0])
            cylinder(h = cyl_h_outer, d = outer_cyl1_d, center = true, $fn = fn);
        translate([0, cyl2_offset, 0])
            cylinder(h = cyl_h_outer, d = outer_cyl2_d, center = true, $fn = fn);
    }

    // Inner shell & interior cylinders
    translate([0, 0, shell_z_offset])
        cube(size = [inner_w, inner_l, inner_h], center = true);

    translate([0, cyl1_offset, shell_z_offset])
        cylinder(h = cyl_h_inner, d = inner_cyl1_d, center = true, $fn = fn);
    translate([0, cyl2_offset, shell_z_offset])
        cylinder(h = cyl_h_inner, d = inner_cyl2_d, center = true, $fn = fn);

    // Slots
    rotate([0, 0, slot_rot_angle]) {
        translate([slot_trans1[0], slot_trans1[1], slot_z_offset])
            cube(size = slot_size, center = true);
    }
    translate([0, slot_trans2[1], slot_z_offset])
        cube(size = slot_size, center = true);
}

// ===== Mechanical connector for bubble gun =====
module adapter(pos = [0, 0, 0]) {
    translate(pos) {
        union() {
            difference() {
                cylinder(h = adapter_h_outer, d = adapter_outer_d, center = false, $fn = fn);
                cylinder(h = adapter_h_outer, d = adapter_inner_d, center = false, $fn = fn);
            }
            translate([0, 0, adapter_h_outer - adapter_cap_h])
                cylinder(h = adapter_cap_h, d = adapter_cap_d, center = false, $fn = fn);
        }
    }
}

// ===== Decorative text =====
module embossed_text(txt, size, depth) {
    translate(text_translate) {
        rotate([0, 0, text_rot_angle])
            translate([0, 0, -size/2])
                linear_extrude(height = depth)
                    text(txt,
                         size = size,
                         font = text_font,
                         halign = "center",
                         valign = "center");
    }
}

// ===== Instantiate modules =====
adapter([0, -10, -5]);
adapter([0, -35, -5]);

embossed_text("Michelle", size = 12, depth = 2);
