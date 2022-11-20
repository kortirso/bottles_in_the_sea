export const componentTypes = ['WorldMap'] as const;

export type ComponentType = typeof componentTypes[number];

export type KeyValue = {
  [key in string]: string;
};

export interface Attribute {
  attributes: any;
}
