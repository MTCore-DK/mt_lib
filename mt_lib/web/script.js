"use strict";

/* =========================================================
   ELEMENTS
========================================================= */

const toastContainer =
    document.getElementById("toast-container");

const progressCircle =
    document.getElementById("progress-circle");

const progressRing =
    document.getElementById("progress-ring");

const progressLabel =
    document.getElementById("progress-label");

const progressIcon =
    document.getElementById("progress-icon");

const targetContainer =
    document.getElementById("target-container");

const targetKey =
    document.getElementById("target-key");

const targetLabel =
    document.getElementById("target-label");

const targetDescription =
    document.getElementById("target-description");

const radialMenu =
    document.getElementById("radial-menu");

const menuContainer =
    document.getElementById("menu-container");

const menuTitle =
    document.getElementById("menu-title");

const menuDescription =
    document.getElementById("menu-description");

const menuItems =
    document.getElementById("menu-items");

const menuClose =
    document.getElementById("menu-close");

const inputContainer =
    document.getElementById("input-container");

const inputTitle =
    document.getElementById("input-title");

const inputDescription =
    document.getElementById("input-description");

const inputForm =
    document.getElementById("input-form");

const inputFields =
    document.getElementById("input-fields");

const inputCancel =
    document.getElementById("input-cancel");

const inputClose =
    document.getElementById("input-close");


/* =========================================================
   STATE
========================================================= */

const CIRCUMFERENCE =
    2 * Math.PI * 52;

let progressTimer = null;

let currentInputFields = [];

let radialVisible = false;
let menuVisible = false;
let inputVisible = false;


/* =========================================================
   INITIALIZE
========================================================= */

if (progressRing) {
    progressRing.style.strokeDasharray =
        CIRCUMFERENCE;

    progressRing.style.strokeDashoffset =
        CIRCUMFERENCE;
}


/* =========================================================
   NUI MESSAGE HANDLER
========================================================= */

window.addEventListener("message", (event) => {

    const data = event.data;

    if (!data || !data.action) {
        return;
    }

    switch (data.action) {

        /* -------------------------------------------------
           NOTIFICATION
        ------------------------------------------------- */

        case "notify":
            showToast(data.data || {});
            break;


        /* -------------------------------------------------
           PROGRESS
        ------------------------------------------------- */

        case "progress":
        case "progressCircle":
            showProgressCircle(
                data.data || data
            );
            break;


        case "hideProgress":
            hideProgressCircle();
            break;


        /* -------------------------------------------------
           TARGET
        ------------------------------------------------- */

        case "target":
            showTarget(data);
            break;


        case "hideTarget":
            hideTarget();
            break;


        /* -------------------------------------------------
           MENU
        ------------------------------------------------- */

        case "menu":
            showMenu(
                data.menu || {}
            );
            break;


        case "hideMenu":
            hideMenu();
            break;


        /* -------------------------------------------------
           INPUT
        ------------------------------------------------- */

        case "input":
            showInput(
                data.title || "Input",
                data.fields || []
            );
            break;


        case "hideInput":
            hideInput(false);
            break;


        /* -------------------------------------------------
           RADIAL
        ------------------------------------------------- */

        case "radialMenu":
            showRadialMenu(data);
            break;


        case "hideRadialMenu":
            hideRadialMenu();
            break;


        /* -------------------------------------------------
           CLOSE EVERYTHING
        ------------------------------------------------- */

        case "close":
            hideAll();
            break;
    }
});


/* =========================================================
   NOTIFICATIONS
========================================================= */

function showToast(data) {

    if (!toastContainer) {
        return;
    }

    const type =
        ["success", "error", "warning", "info"]
            .includes(data.type)
            ? data.type
            : "info";


    const title =
        data.title ||
        capitalize(type);


    const description =
        data.description ||
        data.message ||
        "";


    const duration =
        Math.max(
            Number(data.duration) || 5000,
            500
        );


    const icons = {

        success: "✓",

        error: "×",

        warning: "!",

        info: "i"
    };


    const icon =
        data.icon ||
        icons[type];


    const toast =
        document.createElement("div");

    toast.className =
        `toast ${type}`;


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
            style="animation-duration:${duration}ms"
        ></div>
    `;


    toastContainer.appendChild(toast);


    const timeout =
        setTimeout(() => {

            removeToast(toast);

        }, duration);


    toast.dataset.timeout =
        timeout;
}


/* =========================================================
   REMOVE TOAST
========================================================= */

function removeToast(toast) {

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
}


/* =========================================================
   CLEAR TOASTS
========================================================= */

function clearToasts() {

    if (!toastContainer) {
        return;
    }


    const toasts =
        toastContainer.querySelectorAll(
            ".toast"
        );


    toasts.forEach((toast) => {

        if (toast.dataset.timeout) {
            clearTimeout(
                Number(toast.dataset.timeout)
            );
        }

        removeToast(toast);
    });
}


/* =========================================================
   PROGRESS
========================================================= */

function showProgressCircle(data) {

    if (
        !progressCircle ||
        !progressRing
    ) {
        return;
    }


    clearInterval(progressTimer);


    const duration =
        Math.max(
            Number(data.duration) || 3000,
            100
        );


    const label =
        data.label ||
        "Loading...";


    const icon =
        data.icon ||
        "⏳";


    const color =
        data.color ||
        "primary";


    progressLabel.textContent =
        label;


    progressIcon.textContent =
        icon;


    progressRing.style.stroke =
        getProgressColor(color);


    progressRing.style.strokeDasharray =
        CIRCUMFERENCE;


    progressRing.style.strokeDashoffset =
        CIRCUMFERENCE;


    progressCircle.hidden =
        false;


    progressCircle.style.display =
        "flex";


    const startTime =
        performance.now();


    function update() {

        const elapsed =
            performance.now() -
            startTime;


        const progress =
            Math.min(
                elapsed / duration,
                1
            );


        const offset =
            CIRCUMFERENCE -
            (
                CIRCUMFERENCE *
                progress
            );


        progressRing.style.strokeDashoffset =
            offset;


        if (progress >= 1) {

            clearInterval(
                progressTimer
            );

            progressTimer = null;

            hideProgressCircle();

            return;
        }
    }


    progressTimer =
        setInterval(update, 16);
}


/* =========================================================
   HIDE PROGRESS
========================================================= */

function hideProgressCircle() {

    clearInterval(
        progressTimer
    );

    progressTimer = null;


    if (!progressCircle) {
        return;
    }


    progressCircle.hidden =
        true;


    progressCircle.style.display =
        "none";


    if (progressRing) {

        progressRing.style.strokeDashoffset =
            CIRCUMFERENCE;
    }
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
   TARGET
========================================================= */

function showTarget(data) {

    if (!targetContainer) {
        return;
    }


    const visible =
        data.visible !== false;


    if (!visible) {

        hideTarget();

        return;
    }


    const targetData =
        data.data || data;


    targetKey.textContent =
        targetData.key ||
        "E";


    targetLabel.textContent =
        targetData.label ||
        "Interact";


    targetDescription.textContent =
        targetData.description ||
        "";


    targetContainer.hidden =
        false;


    targetContainer.style.display =
        "flex";
}


/* =========================================================
   HIDE TARGET
========================================================= */

function hideTarget() {

    if (!targetContainer) {
        return;
    }


    targetContainer.hidden =
        true;


    targetContainer.style.display =
        "none";
}


/* =========================================================
   MENU
========================================================= */

function showMenu(menu) {

    if (!menuContainer) {
        return;
    }


    menuVisible = true;


    menuTitle.textContent =
        menu.title ||
        "Menu";


    menuDescription.textContent =
        menu.description ||
        "";


    menuItems.innerHTML =
        "";


    const items =
        Array.isArray(menu.items)
            ? menu.items
            : [];


    items.forEach(
        (item, index) => {

            createMenuItem(
                item,
                index
            );
        }
    );


    menuContainer.hidden =
        false;


    menuContainer.style.display =
        "flex";


    if (menuClose) {

        menuClose.onclick =
            () => {

                hideMenu();

                sendNuiCallback(
                    "menuClose"
                );
            };
    }
}


/* =========================================================
   CREATE MENU ITEM
========================================================= */

function createMenuItem(
    item,
    index
) {

    const element =
        document.createElement("button");


    element.type =
        "button";


    element.className =
        "menu-item";


    if (item.disabled) {
        element.classList.add(
            "disabled"
        );

        element.disabled =
            true;
    }


    element.innerHTML = `

        <div class="menu-item-icon">
            ${escapeHtml(
                item.icon || "•"
            )}
        </div>

        <div class="menu-item-content">

            <div class="menu-item-label">
                ${escapeHtml(
                    item.label ||
                    `Option ${index + 1}`
                )}
            </div>

            ${
                item.description
                    ? `
                        <div
                            class="menu-item-description"
                        >
                            ${escapeHtml(
                                item.description
                            )}
                        </div>
                    `
                    : ""
            }

        </div>
    `;


    if (!item.disabled) {

        element.addEventListener(
            "click",
            () => {

                sendNuiCallback(
                    "menuSelect",
                    {
                        id:
                            item.id ||
                            index,

                        value:
                            item.value
                    }
                );


                if (
                    item.close !== false
                ) {
                    hideMenu();
                }
            }
        );
    }


    menuItems.appendChild(
        element
    );
}


/* =========================================================
   HIDE MENU
========================================================= */

function hideMenu() {

    menuVisible = false;


    if (!menuContainer) {
        return;
    }


    menuContainer.hidden =
        true;


    menuContainer.style.display =
        "none";
}


/* =========================================================
   INPUT DIALOG
========================================================= */

function showInput(
    title,
    fields
) {

    if (!inputContainer) {
        return;
    }


    inputVisible = true;

    currentInputFields =
        Array.isArray(fields)
            ? fields
            : [];


    inputTitle.textContent =
        title ||
        "Input";


    inputDescription.textContent =
        "";


    inputFields.innerHTML =
        "";


    currentInputFields.forEach(
        (field, index) => {

            createInputField(
                field,
                index
            );
        }
    );


    inputContainer.hidden =
        false;


    inputContainer.style.display =
        "flex";
}


/* =========================================================
   CREATE INPUT FIELD
========================================================= */

function createInputField(
    field,
    index
) {

    const wrapper =
        document.createElement("div");


    wrapper.className =
        "input-field";


    const id =
        `mt-input-${index}`;


    const label =
        document.createElement("label");


    label.htmlFor =
        id;


    label.textContent =
        field.label ||
        `Field ${index + 1}`;


    wrapper.appendChild(
        label
    );


    let input;


    switch (field.type) {

        case "textarea":

            input =
                document.createElement(
                    "textarea"
                );

            break;


        case "number":

            input =
                document.createElement(
                    "input"
                );

            input.type =
                "number";

            break;


        case "password":

            input =
                document.createElement(
                    "input"
                );

            input.type =
                "password";

            break;


        case "select":

            input =
                document.createElement(
                    "select"
                );

            createSelectOptions(
                input,
                field.options || []
            );

            break;


        case "checkbox":

            input =
                document.createElement(
                    "input"
                );

            input.type =
                "checkbox";

            break;


        default:

            input =
                document.createElement(
                    "input"
                );

            input.type =
                "text";
    }


    input.id =
        id;


    input.name =
        field.name ||
        `field_${index}`;


    if (
        field.placeholder &&
        input.type !== "checkbox"
    ) {

        input.placeholder =
            field.placeholder;
    }


    if (
        field.default !== undefined
    ) {

        if (
            input.type ===
            "checkbox"
        ) {

            input.checked =
                Boolean(
                    field.default
                );

        } else {

            input.value =
                field.default;
        }
    }


    if (field.required) {
        input.required =
            true;
    }


    if (
        field.description
    ) {

        const description =
            document.createElement(
                "small"
            );

        description.textContent =
            field.description;

        description.style.color =
            "var(--mt-text-muted)";

        description.style.fontSize =
            "10px";

        wrapper.appendChild(
            description
        );
    }


    wrapper.appendChild(
        input
    );


    inputFields.appendChild(
        wrapper
    );
}


/* =========================================================
   SELECT OPTIONS
========================================================= */

function createSelectOptions(
    select,
    options
) {

    options.forEach(
        (option) => {

            const element =
                document.createElement(
                    "option"
                );


            if (
                typeof option ===
                "object"
            ) {

                element.value =
                    option.value;

                element.textContent =
                    option.label ||
                    option.value;

            } else {

                element.value =
                    option;

                element.textContent =
                    option;
            }


            select.appendChild(
                element
            );
        }
    );
}


/* =========================================================
   INPUT SUBMIT
========================================================= */

if (inputForm) {

    inputForm.addEventListener(
        "submit",
        (event) => {

            event.preventDefault();


            const result =
                {};


            currentInputFields.forEach(
                (field, index) => {

                    const element =
                        document.getElementById(
                            `mt-input-${index}`
                        );


                    if (!element) {
                        return;
                    }


                    if (
                        element.type ===
                        "checkbox"
                    ) {

                        result[
                            field.name ||
                            index
                        ] =
                            element.checked;

                    } else {

                        result[
                            field.name ||
                            index
                        ] =
                            element.value;
                    }
                }
            );


            sendNuiCallback(
                "inputSubmit",
                result
            );


            hideInput(
                false
            );
        }
    );
}


/* =========================================================
   INPUT CANCEL
========================================================= */

function cancelInput() {

    sendNuiCallback(
        "inputCancel"
    );

    hideInput(
        false
    );
}


if (inputCancel) {

    inputCancel.addEventListener(
        "click",
        cancelInput
    );
}


if (inputClose) {

    inputClose.addEventListener(
        "click",
        cancelInput
    );
}


/* =========================================================
   HIDE INPUT
========================================================= */

function hideInput(
    callback = true
) {

    inputVisible = false;


    if (!inputContainer) {
        return;
    }


    inputContainer.hidden =
        true;


    inputContainer.style.display =
        "none";


    currentInputFields =
        [];


    if (callback) {

        sendNuiCallback(
            "inputCancel"
        );
    }
}


/* =========================================================
   RADIAL MENU
========================================================= */

function showRadialMenu(data) {

    if (!radialMenu) {
        return;
    }


    radialVisible = true;


    radialMenu.innerHTML =
        "";


    const items =
        Array.isArray(data.items)
            ? data.items
            : [];


    const center =
        document.createElement(
            "button"
        );


    center.type =
        "button";


    center.className =
        "radial-center";


    center.innerHTML =
        "<span>×</span>";


    center.addEventListener(
        "click",
        () => {

            hideRadialMenu();

            sendNuiCallback(
                "closeRadialMenu"
            );
        }
    );


    radialMenu.appendChild(
        center
    );


    const radius =
        Number(data.radius) || 125;


    items.forEach(
        (item, index) => {

            const angle =
                (
                    index /
                    items.length
                ) *
                Math.PI *
                2 -
                Math.PI / 2;


            const x =
                Math.cos(angle) *
                radius;


            const y =
                Math.sin(angle) *
                radius;


            const element =
                document.createElement(
                    "button"
                );


            element.type =
                "button";


            element.className =
                "radial-item";


            element.style.left =
                "50%";


            element.style.top =
                "50%";


            element.style.transform =
                `translate(calc(-50% + ${x}px), calc(-50% + ${y}px))`;


            element.innerHTML = `

                <div class="radial-item-icon">
                    ${escapeHtml(
                        item.icon || "•"
                    )}
                </div>

                <div class="radial-item-label">
                    ${escapeHtml(
                        item.label || ""
                    )}
                </div>
            `;


            element.addEventListener(
                "click",
                () => {

                    sendNuiCallback(
                        "radialSelect",
                        {
                            id:
                                item.id ||
                                index,

                            value:
                                item.value
                        }
                    );


                    hideRadialMenu();
                }
            );


            radialMenu.appendChild(
                element
            );
        }
    );


    radialMenu.hidden =
        false;


    radialMenu.style.display =
        "flex";
}


/* =========================================================
   HIDE RADIAL
========================================================= */

function hideRadialMenu() {

    radialVisible = false;


    if (!radialMenu) {
        return;
    }


    radialMenu.hidden =
        true;


    radialMenu.style.display =
        "none";


    radialMenu.innerHTML =
        "";
}


/* =========================================================
   HIDE ALL
========================================================= */

function hideAll() {

    clearToasts();

    hideProgressCircle();

    hideTarget();

    hideRadialMenu();

    hideMenu();

    hideInput(
        false
    );
}


/* =========================================================
   KEYBOARD
========================================================= */

document.addEventListener(
    "keydown",
    (event) => {

        if (
            event.key !==
            "Escape"
        ) {
            return;
        }


        if (inputVisible) {

            cancelInput();

            return;
        }


        if (menuVisible) {

            hideMenu();

            sendNuiCallback(
                "menuClose"
            );

            return;
        }


        if (radialVisible) {

            hideRadialMenu();

            sendNuiCallback(
                "closeRadialMenu"
            );

            return;
        }


        if (progressCircle) {

            if (
                !progressCircle.hidden
            ) {

                hideProgressCircle();
            }
        }
    }
);


/* =========================================================
   NUI CALLBACK
========================================================= */

function sendNuiCallback(
    action,
    data = {}
) {

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

            body:
                JSON.stringify(data)
        }
    ).catch(() => {
        // Ignore NUI errors
    });
}


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
