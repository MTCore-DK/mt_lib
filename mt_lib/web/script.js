const toastContainer = document.getElementById("toast-container");

const progressCircle = document.getElementById("progress-circle");
const progressRing = document.getElementById("progress-ring");
const progressLabel = document.getElementById("progress-label");
const progressIcon = document.getElementById("progress-icon");

const radialMenu = document.getElementById("radial-menu");

const CIRCUMFERENCE = 2 * Math.PI * 52;

progressRing.style.strokeDasharray = CIRCUMFERENCE;
progressRing.style.strokeDashoffset = CIRCUMFERENCE;


/* =========================================================
   NUI MESSAGE LISTENER
========================================================= */

window.addEventListener("message", (event) => {
    const data = event.data;

    if (!data || !data.action) {
        return;
    }

    switch (data.action) {

        case "progressCircle":
            showProgressCircle(data);
            break;

        case "toast":
            showToast(data);
            break;

        case "radialMenu":
            showRadialMenu(data);
            break;

        case "hideRadialMenu":
            hideRadialMenu();
            break;
    }
});


/* =========================================================
   PROGRESS CIRCLE
========================================================= */

let progressTimer = null;

function showProgressCircle(data) {

    clearInterval(progressTimer);

    const duration = Number(data.duration) || 5000;

    const label = data.label || "Loading...";
    const icon = data.icon || "⏳";

    progressLabel.textContent = label;
    progressIcon.textContent = icon;

    progressCircle.style.display = "flex";

    progressRing.style.stroke = getProgressColor(
        data.color
    );

    progressRing.style.strokeDashoffset = CIRCUMFERENCE;

    const startTime = performance.now();

    progressTimer = setInterval(() => {

        const elapsed = performance.now() - startTime;

        const progress = Math.min(
            elapsed / duration,
            1
        );

        const offset =
            CIRCUMFERENCE -
            (CIRCUMFERENCE * progress);

        progressRing.style.strokeDashoffset = offset;

        if (progress >= 1) {

            clearInterval(progressTimer);

            progressTimer = null;

            hideProgressCircle();
        }

    }, 16);
}


function hideProgressCircle() {

    progressCircle.style.display = "none";

    progressRing.style.strokeDashoffset =
        CIRCUMFERENCE;
}


function getProgressColor(color) {

    const colors = {
        primary: "#6366f1",
        success: "#22c55e",
        error: "#ef4444",
        warning: "#f59e0b",
        info: "#3b82f6"
    };

    return colors[color] || colors.primary;
}


/* =========================================================
   TOAST
========================================================= */

function showToast(data) {

    const type = data.type || "info";

    const title =
        data.title ||
        capitalize(type);

    const description =
        data.description ||
        data.message ||
        "";

    const duration =
        Number(data.duration) || 5000;

    const icons = {
        success: "✓",
        error: "✕",
        warning: "!",
        info: "i"
    };

    const icon =
        data.icon ||
        icons[type] ||
        "i";


    const toast = document.createElement("div");

    toast.className = `toast ${type}`;

    toast.innerHTML = `
        <div class="toast-icon">
            ${escapeHtml(icon)}
        </div>

        <div class="toast-content">
            <div class="toast-title">
                ${escapeHtml(title)}
            </div>

            <div class="toast-description">
                ${escapeHtml(description)}
            </div>
        </div>

        <div
            class="toast-progress"
            style="animation-duration: ${duration}ms"
        ></div>
    `;

    toastContainer.appendChild(toast);


    setTimeout(() => {

        toast.style.animation =
            "toast-out 0.2s ease forwards";

        setTimeout(() => {
            toast.remove();
        }, 200);

    }, duration);
}


/* =========================================================
   RADIAL MENU
========================================================= */

function showRadialMenu(data) {

    radialMenu.innerHTML = "";

    const items = data.items || [];

    const center = document.createElement("div");

    center.className = "radial-center";

    center.innerHTML = `
        <span>✕</span>
    `;

    radialMenu.appendChild(center);


    const radius = 125;

    items.forEach((item, index) => {

        const angle =
            (index / items.length) *
            Math.PI * 2 -
            Math.PI / 2;

        const x =
            Math.cos(angle) * radius;

        const y =
            Math.sin(angle) * radius;


        const element =
            document.createElement("div");

        element.className =
            "radial-item";

        element.style.transform =
            `translate(${x}px, ${y}px)`;

        element.innerHTML = `
            <div class="radial-item-icon">
                ${escapeHtml(item.icon || "•")}
            </div>

            <div class="radial-item-label">
                ${escapeHtml(item.label || "")}
            </div>
        `;


        element.addEventListener("click", () => {

            window.parent.postMessage({
                action: "radialSelect",
                id: item.id
            }, "*");

        });


        radialMenu.appendChild(element);
    });


    radialMenu.style.display = "flex";

    radialMenu.style.animation =
        "radial-in 0.15s ease forwards";
}


function hideRadialMenu() {

    radialMenu.style.display = "none";

    radialMenu.innerHTML = `
        <div class="radial-center">
            <span>✕</span>
        </div>
    `;
}


/* =========================================================
   HELPERS
========================================================= */

function capitalize(value) {

    if (!value) {
        return "";
    }

    return value.charAt(0).toUpperCase() +
        value.slice(1);
}


function escapeHtml(value) {

    return String(value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}


/* =========================================================
   ESCAPE = CLOSE RADIAL MENU
========================================================= */

document.addEventListener("keydown", (event) => {

    if (event.key === "Escape") {

        if (radialMenu.style.display !== "none") {

            hideRadialMenu();

            window.parent.postMessage({
                action: "closeRadialMenu"
            }, "*");
        }
    }
});
