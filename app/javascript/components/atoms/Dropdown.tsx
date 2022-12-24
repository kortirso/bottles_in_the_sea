import React, { useState } from 'react';

import type { KeyValue } from 'entities';

interface DropdownProps {
  title: string;
  items: KeyValue;
  placeholder?: string;
  onSelect: (value: string) => void;
  selectedItem?: string;
}

export const Dropdown = ({ title, items, placeholder, onSelect, selectedItem }: DropdownProps): JSX.Element => {
  const [isOpen, setIsOpen] = useState<boolean>(false);

  const selectValue = (value: string) => {
    onSelect(value);
    setIsOpen(false);
  };

  return (
    <div className="form-field">
      <label className="form-label">{title}</label>
      <div className="form-select">
        <div className="form-value" onClick={() => setIsOpen(!isOpen)}>
          {selectedItem ? items[selectedItem] : placeholder}
        </div>
        {isOpen && (
          <ul className="form-select-dropdown">
            {Object.entries(items).map(([key, value], index) => (
              <li onClick={() => selectValue(key)} key={index}>
                {value}
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
};
