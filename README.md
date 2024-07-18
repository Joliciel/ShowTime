### Title: Time Formatting Utility - ShowTime and Hour Functions

---

### Description:

The `ShowTime` function is designed to convert a numeric value into a formatted time string, accommodating various time units from hundredths of a second to years. The function offers extensive customization options for time formatting and suffixes, supporting both English and French languages, as well as user-defined formats. It can be used in a variety of applications including reports, timers, and elapsed time calculations. 

---

### Key Features:

- **Time Formatting:** Supports a wide range of time formats, from simple hours and minutes to complex combinations of years, months, weeks, days, and smaller time units.
- **Customizable Suffixes:** Allows for the use of custom suffixes and messages, supporting multiple languages and formats.
- **Versatility:** Suitable for use in various types of procedures such as menus, tables, forms, reports, and batch processes.
- **Ease of Use:** Simplifies the conversion of computed time into human-readable strings with a single function call.

---

### Usage:

To use the `ShowTime` function, you need to pass the computed time along with optional parameters for format, suffix, language, and external arrays. Here is an example of how to implement and call the function:

```clarion
CODE
begTime = CLOCK()
LOOP
  endTime = CLOCK()
  cTime = endTime - begTime + 1
  Pre:sTime = ShowTime(cTime, '@t1', '!', 1)
  Pre:sTime = ShowTime(cTime)  ! Use the internal default format
END
```

In this example, the elapsed time is calculated and formatted according to the specified picture format and suffix.

---

### Installation:

Include the `ShowTime` function module (`ShowTime.clw`) in your project and ensure it is correctly mapped. You can customize the function further by defining external suffix and message arrays if needed.

---

### Contribution:

Feel free to contribute by submitting pull requests or opening issues for any bugs or feature requests. Contributions are welcome to improve the functionality and flexibility of the `ShowTime` function.

---

### License:

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
