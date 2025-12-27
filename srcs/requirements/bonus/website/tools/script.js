document.addEventListener("DOMContentLoaded", () => {
    // This function simulates fetching data from the 42 API.
    // In a real application, this would call your backend service,
    // which would then securely call the 42 API with your secret key.
    async function fetch42DataMock() {
        // Simulate a network delay for realism
        await new Promise(resolve => setTimeout(resolve, 1500));

        // Mock data based on your profile
        const mockData = {
            level: 6.0, // Example level
            progress: 71, // Example project percentage
            campus: "Khouribga",
            login: "oel-hadr"
        };

        return mockData;
    }

    // Function to update the UI with the fetched data
    async function updateStatsUI() {
        const levelEl = document.getElementById("stat-level");
        const progressEl = document.getElementById("stat-progress");
        const progressBarEl = document.getElementById("stat-progress-bar");
        const campusEl = document.getElementById("stat-campus");

        // Get elements to remove loading class
        const statCircle = document.querySelector(".stat-circle");
        const statBarContainer = document.querySelector(".stat-bar-container");
        const campusIcon = document.querySelector(".campus-icon");

        try {
            const data = await fetch42DataMock();

            // Remove loading animations
            statCircle.classList.remove("loading");
            statBarContainer.classList.remove("loading");
            campusIcon.classList.remove("loading");

            // Populate data
            levelEl.textContent = data.level.toFixed(2);
            progressEl.textContent = `${data.progress}%`;
            progressBarEl.style.width = `${data.progress}%`;
            campusEl.textContent = data.campus;

        } catch (error) {
            console.error("Failed to fetch 42 API data:", error);
            levelEl.textContent = "Error";
            progressEl.textContent = "Error";
            campusEl.textContent = "Error";
        }
    }

    // Call the function to update the UI
    updateStatsUI();
});