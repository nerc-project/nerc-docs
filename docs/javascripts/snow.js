// snowfall.js

// Array of snowflake symbols
const snowflakeSymbols = ['❄', '✦', '✧', '✺', '✶', '❅'];

// Variables to control snowfall speed
let snowfallSpeed = 100; // Frequency of snowflake creation (in milliseconds)
let fallDurationRange = { min: 5, max: 10 }; // Fall speed (in seconds)

// Function to create a snowflake element
function createSnowflake() {
  const snowflake = document.createElement('div');
  snowflake.classList.add('snowflake');

  // Randomly decide which symbol to use for the snowflake
  const randomSymbol = snowflakeSymbols[Math.floor(Math.random() * snowflakeSymbols.length)];
  snowflake.innerHTML = randomSymbol;
  snowflake.style.fontSize = Math.random() * 10 + 10 + 'px'; // Random font size between 10px and 20px
  snowflake.style.color = 'white'; // Snowflake color
  snowflake.style.opacity = 0.8; // Slight opacity for a soft effect

  // Set a random horizontal position for the snowflake
  const position = Math.random() * window.innerWidth + 'px';
  const fallDuration = Math.random() * (fallDurationRange.max - fallDurationRange.min) + fallDurationRange.min;

  snowflake.style.left = position; // Set snowflake horizontal position
  snowflake.style.animationDuration = fallDuration + 's'; // Set fall speed

  // Append the snowflake to the body
  document.body.appendChild(snowflake);

  // Remove the snowflake after it has fallen
  setTimeout(() => {
    snowflake.remove();
  }, fallDuration * 1000); // Remove after the fall duration (converted to ms)
}

// Start the snowfall effect by creating snowflakes at intervals
function startSnowfall() {
  setInterval(createSnowflake, snowfallSpeed);
}

// Start the snowfall effect when the page loads
startSnowfall();