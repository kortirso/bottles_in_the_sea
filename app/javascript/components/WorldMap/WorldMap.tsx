import React, { useEffect } from 'react';

export const WorldMap = (): JSX.Element => {
  useEffect(() => {
    const canvas = document.getElementById('world-map-canvas');
    const ctx = canvas.getContext('2d');

    const a = 2 * Math.PI / 6;
    const r = 25;

    const drawGrid = (cols, rows) => {
      for (let y = r, i = 0; i < rows; y += r * Math.sin(a) + 2, i++) {
        for (let x = r, j = 0; j < cols; x += r * (1 + Math.cos(a)) + 2, y += (-1) ** j++ * r * Math.sin(a)) {
          drawHexagon(x, y);
        }
      }
    }

    function drawHexagon(x, y) {
      ctx.beginPath();
      for (var i = 0; i < 6; i++) {
        ctx.lineTo(x + r * Math.cos(a * i), y + r * Math.sin(a * i));
      }
      ctx.fillStyle = '#38bdf8';
      ctx.strokeStyle = '#38bdf8';
      ctx.fill();
      ctx.closePath();
      ctx.stroke();
    }

    drawGrid(21, 11);
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <canvas id="world-map-canvas" width="1024" height="550"></canvas>
  );
};
