export const componentTypes = ['WorldMap'] as const;

export type ComponentType = typeof componentTypes[number];
