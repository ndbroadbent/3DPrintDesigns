include <base.scad>;

ADAPTER_MIDDLE_HEIGHT = 20;

threaded_tube(h = CONNECTOR_LENGTH, d = OUTER_DIAMETER_40MM,
              pitch = PITCH_40MM);

move_up(CONNECTOR_LENGTH)
    tube(h = ADAPTER_MIDDLE_HEIGHT, thickness = WALL_THICKNESS,
         d1 = OUTER_DIAMETER_40MM + WALL_THICKNESS * 2,
         d2 = OUTER_DIAMETER_50MM + WALL_THICKNESS * 2);

move_up(CONNECTOR_LENGTH + ADAPTER_MIDDLE_HEIGHT)
    threaded_tube(h = CONNECTOR_LENGTH, d = OUTER_DIAMETER_50MM,
                  pitch = PITCH_50MM);
