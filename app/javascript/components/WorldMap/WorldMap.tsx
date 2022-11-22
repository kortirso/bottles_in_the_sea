import React, { useEffect, useState } from 'react';

import { hexagons } from 'data';

export const WorldMap = (): JSX.Element => {
  const [mapPoint, setMapPoint] = useState();

  const drawWorldCells = () => {
    const canvas = document.getElementById('world-map-canvas');
    const ctx = canvas.getContext('2d');

    // render hexagons on the map
    hexagons.forEach(hexagon => {
      let path = new Path2D(hexagon.svg_path);
      ctx.fillStyle = hexagon.surface === 'ground' ? '#4ade80' : '#38bdf8';
      ctx.strokeStyle = '#fff';
      ctx.fill(path);
      ctx.stroke(path);
    });

    const isIntersect = (point, hexagon) => {
      return Math.sqrt((point.x - hexagon.center_x) ** 2 + (point.y - hexagon.center_y) ** 2) < 17.3;
    };

    // catch hexagons clicks
    canvas.addEventListener('click', (e) => {
      const pos = { x: e.offsetX, y: e.offsetY };
      hexagons.find(hexagon => {
        if (isIntersect(pos, hexagon)) setMapPoint([hexagon.column, hexagon.row])
      });
    });
  };

  useEffect(() => {
    drawWorldCells();
  }, []);

  return (
    <>
      <div id="world-map-wrapper">
        <canvas id="world-map-canvas" width="1024" height="550"></canvas>
      </div>
      <div id="world-map-forms">
        {mapPoint ? (
          <h2>Selected hex - {mapPoint[0]}-{mapPoint[1]}</h2>
        ) : (
          <h2>Select hex</h2>
        )}
      </div>
    </>
  );
};
