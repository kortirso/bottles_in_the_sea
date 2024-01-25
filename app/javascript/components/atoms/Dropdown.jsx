import React, { useState } from 'react';

export const Dropdown = ({ title, items, placeholder, onSelect, selectedItem }) => {
  const [isOpen, setIsOpen] = useState(false);

  const selectValue = (value) => {
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
