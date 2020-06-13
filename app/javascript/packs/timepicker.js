require("flatpickr")

$('.datepicker').flatpickr({
    enableTime: true,
    time_24hr: true,
    altInput: true,
    dateFormat: 'Y-m-d H:i:S \\U\\T\\C',
    altFormat: "d/m/Y H:i"
});
