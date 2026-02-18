export function noise(x, z) {
    let y = 0;
    y += (Math.sin(x * 0.01) + Math.cos(z * 0.01)) * 15;
    y += (Math.sin(x * 0.03 + 1.5) * Math.cos(z * 0.025 + 0.5)) * 10;
    y += (Math.sin(x * 0.1) + Math.cos(z * 0.08)) * 2;
    y += Math.sin(x * 0.2) * Math.cos(z * 0.2) * 1;
    y = y + Math.pow(Math.abs(Math.sin(x * 0.005) * Math.cos(z * 0.005)), 2) * 40;
    return y;
}

export function getRiverPath(z) {
    // Offset by 250 to avoid spawn area
    return 250 + Math.sin(z * 0.005) * 100 + Math.sin(z * 0.02) * 20;
}

export function getRiverSurfaceY(z) {
    // Slope from 50 to -10 over z=-600 to 600
    // Lowered to ensure it cuts into terrain
    return 20 - (z / 600) * 30;
}

export function getTerrainHeight(x, z) {
    let height = noise(x, z);

    // River Logic
    const riverCenter = getRiverPath(z);
    const bankWidth = 35;
    const riverSurfaceY = getRiverSurfaceY(z);

    const distToRiver = Math.abs(x - riverCenter);

    if (distToRiver < bankWidth) {
        const t = distToRiver / bankWidth;
        const bankHeight = height;
        const bedHeight = riverSurfaceY - 4;
        const blend = t * t * (3 - 2 * t);
        // Only carve DOWN, don't raise -> INCORRECT.
        // We must sculpt the bed even if we need to raise ground (fill valleys).
        // Otherwise water floats.
        height = bedHeight + (bankHeight - bedHeight) * blend;
    }

    // Flatten center
    const dist = Math.sqrt(x * x + z * z);
    if (dist < 100) {
        const factor = Math.max(0, (dist - 20) / 80);
        height = height * factor * factor;
        if (height < 1) height = 1;
    } else {
        height += Math.max(0, (dist - 100) * 0.15);
    }

    if (height < 0.5) height = 0.5;
    return height;
}

export function isRiver(x, z) {
    const riverCenter = getRiverPath(z);
    const distToRiver = Math.abs(x - riverCenter);
    // River width is 14, give margin
    return distToRiver < 10;
}
