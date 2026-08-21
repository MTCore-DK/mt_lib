const toastContainer = document.getElementById("toast-container");

const progressCircle = document.getElementById("progress-circle");
const progressRing = document.getElementById("progress-ring");
const progressLabel = document.getElementById("progress-label");
const progressIcon = document.getElementById("progress-icon");

const radialMenu = document.getElementById("radial-menu");

const CIRCUMFERENCE = 2 * Math.PI * 52;

let progressTimer = null;

progressRing.style.strokeDasharray = CIRCUMFERENCE;
progressRing.style.strokeDashoffset = CIRCUMFERENCE;


/* =========================================================
   NUI MESSAGE HANDLER
========================================================= */

window.addEventListener("message", (event) => {
    const data = event.data;

    if (!data || !data.action) {
        return;
    }

    switch (data.action) {

        case "notify":
            showToast(data.data || {});
            break;

        case "progressCircle":
            showProgressCircle(data);
            break;

        case "radialMenu":
            showRadialMenu(data);
            break;

        case "hideRadialMenu":
            hideRadialMenu();
            break;

        case "close":
            hideAll();
            break;
    }
});


/* =========================================================
   NOTIFICATION / TOAST
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
        icons.info;


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


    // Remove notification after duration
    setTimeout(() => {

        if (!toast || !toast.parentNode) {
            return;
        }

        toast.style.animation =
            "toast-out 0.2s ease forwards";

        setTimeout(() => {

            if (toast.parentNode) {
                toast.remove();
            }

        }, 200);

    }, duration);
}


/* =========================================================
   CLEAR ALL NOTIFICATIONS
========================================================= */

function clearToasts() {

    const toasts =
        toastContainer.querySelectorAll(".toast");

    toasts.forEach((toast) => {

        toast.style.animation =
            "toast-out 0.2s ease forwards";

        setTimeout(() => {

            if (toast.parentNode) {
                toast.remove();
            }

        }, 200);
    });
}


/* =========================================================
   PROGRESS CIRCLE
========================================================= */

function showProgressCircle(data) {

    clearInterval(progressTimer);

    const duration =
        Number(data.duration) || 5000;

    const label =
        data.label || "Loading...";

    const icon =
        data.icon || "⏳";

    const color =
        data.color || "primary";


    progressLabel.textContent = label;

    progressIcon.textContent = icon;


    progressRing.style.stroke =
        getProgressColor(color);

    progressRing.style.strokeDasharray =
        CIRCUMFERENCE;

    progressRing.style.strokeDashoffset =
        CIRCUMFERENCE;


    progressCircle.style.display = "flex";


    const startTime =
        performance.now();


    progressTimer = setInterval(() => {

        const elapsed =
            performance.now() - startTime;

        const progress =
            Math.min(elapsed / duration, 1);


        const offset =
            CIRCUMFERENCE -
            (CIRCUMFERENCE * progress);


        progressRing.style.strokeDashoffset =
            offset;


        if (progress >= 1) {

            clearInterval(progressTimer);

            progressTimer = null;

            hideProgressCircle();
        }

    }, 16);
}


/* =========================================================
   HIDE PROGRESS
========================================================= */

function hideProgressCircle() {

    clearInterval(progressTimer);

    progressTimer = null;

    progressCircle.style.display =
        "none";

    progressRing.style.strokeDashoffset =
        CIRCUMFERENCE;
}


/* =========================================================
   PROGRESS COLORS
========================================================= */

function getProgressColor(color) {

    const colors = {

        primary: "#6366f1",

        success: "#22c55e",

        error: "#ef4444",

        warning: "#f59e0b",

        info: "#3b82f6"
    };


    return colors[color] ||
        colors.primary;
}


/* =========================================================
   RADIAL MENU
========================================================= */

function showRadialMenu(data) {

    const items =
        Array.isArray(data.items)
            ? data.items
            : [];


    radialMenu.innerHTML = "";


    /*
        Center button
    */

    const center =
        document.createElement("div");

    center.className =
        "radial-center";

    center.innerHTML = `
        <span>✕</span>
    `;


    center.addEventListener("click", () => {

        hideRadialMenu();

        sendNuiCallback(
            "closeRadialMenu"
        );
    });


    radialMenu.appendChild(center);


    /*
        No items
    */

    if (items.length === 0) {

        radialMenu.style.display =
            "flex";

        return;
    }


    /*
        Radial item positions
    */

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


        element.addEventListener(
            "click",
            () => {

                sendNuiCallback(
                    "radialSelect",
                    {
                        id: item.id
                    }
                );

                hideRadialMenu();
            }
        );


        radialMenu.appendChild(element);
    });


    radialMenu.style.display =
        "flex";

    radialMenu.style.animation =
        "radial-in 0.15s ease forwards";
}


/* =========================================================
   HIDE RADIAL MENU
========================================================= */

function hideRadialMenu() {

    radialMenu.style.display =
        "none";

    radialMenu.innerHTML = `
        <div class="radial-center">
            <span>✕</span>
        </div>
    `;
}


/* =========================================================
   HIDE EVERYTHING
========================================================= */

function hideAll() {

    clearToasts();

    hideProgressCircle();

    hideRadialMenu();
}


/* =========================================================
   NUI CALLBACK
========================================================= */

function sendNuiCallback(action, data = {}) {

    /*
        FiveM NUI callback.

        resource name is automatically resolved
        by GetParentResourceName().
    */

    if (
        typeof GetParentResourceName !==
        "function"
    ) {
        return;
    }


    fetch(
        `https://${GetParentResourceName()}/${action}`,
        {
            method: "POST",

            headers: {
                "Content-Type":
                    "application/json; charset=UTF-8"
            },

            body: JSON.stringify(data)
        }
    ).catch(() => {
        // Ignore NUI callback errors
    });
}


/* =========================================================
   KEYBOARD
========================================================= */

document.addEventListener(
    "keydown",
    (event) => {

        if (event.key !== "Escape") {
            return;
        }


        if (
            radialMenu.style.display !==
            "none"
        ) {

            hideRadialMenu();

            sendNuiCallback(
                "closeRadialMenu"
            );
        }
    }
);


/* =========================================================
   HELPERS
========================================================= */

function capitalize(value) {

    if (!value) {
        return "";
    }


    return (
        value.charAt(0).toUpperCase() +
        value.slice(1)
    );
}


function escapeHtml(value) {

    return String(value)

        .replace(
            /&/g,
            "&amp;"
        )

        .replace(
            /</g,
            "&lt;"
        )

        .replace(
            />/g,
            "&gt;"
        )

        .replace(
            /"/g,
            "&quot;"
        )

        .replace(
            /'/g,
            "&#039;"
        );
}
