import 'package:flutter/material.dart';

class SyllabusScreen extends StatefulWidget {
  const SyllabusScreen({super.key});

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  int selectedSemester = 5;
  String? selectedSubject;

  final List<String> semesters = [
    "Sem 1",
    "Sem 2",
    "Sem 3",
    "Sem 4",
    "Sem 5",
    "Sem 6",
  ];

  final Map<String, List<String>> sem5Subjects = {
    "Web Technologies": [
      "Module I\n"
          "PHP: Introduction, Embedding PHP in HTML, Adding dynamic contents, "
          "Accessing Form variables, Identifiers, Examining variable types, "
          "Declaring and using constants, Variable scope, Operators, Precedence "
          "and Associativity, Making decisions with conditionals, Iteration, "
          "Using Arrays.\n\n"
          "Introduction to Bootstrap: Design web page look and feel good by "
          "using Bootstrap, basics of Bootstrap Framework, Bootstrap Components, "
          "Advantages of Bootstrap Components, Responsive web pages.",

      "Module II\n"
          "Reusing Code And Writing Functions: Advantages, require() and include(), "
          "using functions in PHP, defining own functions, basic function structure, "
          "using parameters, scope, passing by reference versus passing by values, "
          "return keyword.\n\n"
          "Object-Oriented PHP: Constructors, Static class members, Autoloading "
          "objects, inheritance and types, interfaces, abstract classes, error "
          "logging, exceptional handling, Strings, Regular expressions and other "
          "string functions.",

      "Module III\n"
          "Database Connectivity: Using PHP to Access MySQL, Database APIs in PHP, "
          "Connecting to MySQL with PHP, Retrieving data from MySQL, Working with "
          "retrieved data, Creating records with PHP, Updating and deleting records "
          "with PHP.",

      "Module IV\n"
          "Client Side Scripting: Introduction to JavaScript, JavaScript language, "
          "declaring variables, scope of variables, functions, event handlers "
          "(onclick, onsubmit etc.), Document Object Model, Form validations, "
          "Pass By Value in JavaScript, Function return, Nested functions, "
          "Rest parameter, Anonymous functions, Recursion, Arrow Function.",

      "Module V\n"
          "jQuery – Basics: String, Numbers, Boolean, Objects, Arrays, Functions, "
          "Arguments, Scope, Built-in Functions, Introduction to jQuery UI, "
          "jQuery UI in real websites, Downloading jQuery UI, Importing jQuery UI.\n\n"
          "jQuery UI interactions: Draggable, Droppable, Resizable, Selectable, "
          "Sortable.\n\n"
          "jQuery UI widgets: Accordion, Auto Complete, Button Set, Date Picker, "
          "Dialog, Menu, Progress Bar, Slider, Spinner, Tabs, Tooltip.\n\n"
          "jQuery UI effects: Color Animation, Easing, Effect, add Class, "
          "remove Class.",
    ],

    "Advanced Java Programming": [
      "Module I\n"
          "Understanding Java EE: Understanding Java EE - Enterprise Application - "
          "Java Enterprise Edition - Java EE Technologies - Java EE evolution - "
          "Glassfish Server.\n\n"
          "Java EE Architecture, Server And Containers: Types Of System Architecture, "
          "Java EE Server, Java EE Containers.\n\n"
          "Java Servlets: Introduction To Java Servlets, Java Servlet Technology.\n\n"
          "Working With Servlets: Using Annotations Instead Of Deployment Descriptor, "
          "Servlet simple programs.",

      "Module II\n"
          "Request Dispatcher: Request dispatcher Interface, Methods Of Request "
          "dispatcher, Request dispatcher Application.\n\n"
          "Cookies: Kinds Of Cookies, Creating Cookies Using Servlet, Dynamically "
          "Changing The Colours of a Page.\n\n"
          "Session: Lifecycle Of Http Session, Session Tracking With Servlet API, "
          "A Servlet Session Example.\n\n"
          "Working With Files: Uploading Files, Creating An Upload File.",

      "Module III\n"
          "Working With Non-Blocking I/O: Creating A Non-Blocking Read Application, "
          "Creating The Web Application, Creating Java Class, Creating Servlets, "
          "Retrieving The File, Creating index.jsp.\n\n"
          "Java Server Pages: Introduction To Java Server Pages, JSP Vs Servlets, "
          "Life Cycle Of A JSP Page, Comments, JSP Document, JSP Elements, JSP GUI "
          "Example.\n\n"
          "Action Elements: Including Other Files, Forwarding JSP Page To Another "
          "Page, Passing Parameters For Other Actions, Loading A JavaBean.",

      "Module IV\n"
          "Implicit Objects Scope And EL Expressions: Implicit Objects, Character "
          "Quoting Conventions, Unified Expression Language (EL), Expression Language.\n\n"
          "Java Server Pages Standard Tag Libraries: JSTL, Tag Libraries.\n\n"
          "Java Web Frameworks: Spring MVC Overview of Spring, Spring Architecture, "
          "bean life cycle, XML Configuration on Spring, Aspect-oriented Spring, "
          "Managing Database, and Managing Transaction.",

      "Module V\n"
          "Persistence, Object/Relational Mapping And JPA: Persistence In Java, "
          "Current Persistence Standards In Java, Object/Relational Mapping.\n\n"
          "JAVA Persistence API: Introduction To Java Persistence API, The Java "
          "Persistence API, JPA, ORM, Database And The Application Architecture Of JPA, "
          "How JPA Works, JPA Specifications.",
    ],

    "Mobile Application Development": [
      "Module I\n"
          "Introduction Android: Android, Android applications, The manifest file, "
          "Downloading and installing Android, Exploring the development environment, "
          "Developing and executing the first Android application.\n\n"
          "Mobile Application Development: Mobile Applications and Device Platforms, "
          "Alternatives for Building Mobile Apps, Comparing Native vs. Hybrid "
          "Applications, The Mobile Application Development Lifecycle, The Mobile "
          "Application Front-End, The Mobile Application Back-End, Key Mobile "
          "Application Services.",

      "Module II\n"
          "Understanding Activities, Linking Activities Using Intents, Fragments, "
          "Displaying Notifications, Understanding the Components of a Screen, "
          "Adapting to Display Orientation, Managing Changes to Screen Orientation, "
          "Utilizing the Action Bar, Creating the User Interface Programmatically, "
          "Listening for UI Notifications.",

      "Module III\n"
          "Using Basic Views, Using Picker Views, Using List Views to Display Long "
          "Lists, Understanding Specialized Fragments, Using Image Views to Display "
          "Pictures, Using Menus with Views, Using Web View, Saving and Loading User "
          "Preferences, Persisting Data to Files, Creating and Using Firebase.",

      "Module IV\n"
          "Sharing Data in Android, Creating Your Own Content Providers, Using the "
          "Content Provider, SMS Messaging, Sending Email, Displaying Maps, Getting "
          "Location Data, Monitoring a Location.",

      "Module V\n"
          "Introducing Flutter and getting started, Creating a Hello World App, "
          "Using Common Widgets, Adding Animation to an App, Creating an app "
          "navigation, Creating Scrolling List and Effects, Building Layouts.",
    ],

    "WT Lab": [
      "1. Design a web page to get name of the user from a form and show the greeting text.",
      "2. Write and implement Age calculator program.",
      "3. Create a Registration form containing Name, Roll No, Gender and Submit Button using PHP. Display details on the server side.",
      "4. Design a small web application in PHP to access blood donors list from MySQL Donor Table.",
      "5. Create responsive websites using Bootstrap components.",
      "6. Develop a PHP function that checks whether a passed string is a palindrome or not.",
      "7. Write a PHP program to implement inheritance in PHP.",
      "8. Create a PHP program to implement string functions.",
      "9. Write a PHP program to implement DivideByZeroException and DivideByNegativeNoException.",
      "10. Implement a PHP program to design a user defined Exception.",
      "11. Design a user authentication webpage in PHP with MYSQL to check username and password.",
      "12. Write a PHP program to create, update and delete table rows.",
      "13. Set the borders in different colours to a jQuery object by adding the paragraphs.",
      "14. Using jQuery add class named PSG_color and PSG_background to the last paragraph element. Add a new class to an element that already has a class using jQuery.",
      "15. Write a jQuery to insert HTML after all paragraphs and implement a jQuery program to insert a DOM element after all paragraphs.",
    ],

    "MAD Lab": [
      "1. Installation and configuration of Android in Windows OS.",
      "2. Develop a program using two EditText, TextView and Button widgets in Android and perform addition of two numbers.",
      "3. Create a program and demonstrate graphical layout orientation.",
      "4. Develop an application to display personal details using GUI components.",
      "5. Demonstrate List Box, Combo Box, Spinners with Toast.",
      "6. Demonstrate TextArea, Check Box and Radio Button with Toast.",
      "7. Design a program to create quiz using its API controls.",
      "8. Develop an application that uses Layout Managers.",
      "9. Implement an application that creates an alert upon receiving messages.",
      "10. Design a program to demonstrate Graphics and Animation.",
      "11. Develop an application using Notification Manager and send messages from one mobile to another mobile.",
      "12. Design a simple mobile game application.",
      "13. Develop an application that uses audio mode: NORMAL, SILENT, VIBRATE.",
      "14. Develop a mobile application to send an email.",
      "15. Design an application for Login and getting personal details using Firebase.",
    ],

    "AJava Lab": [
      "1. Develop a JAVA Servlet Program to implement and demonstrate GET() and POST() methods using HTTP Servlet class.",
      "2. Implement a JAVA Servlet Program to implement Request Dispatcher object using include() and forward() methods.",
      "3. Create a Java JSP program to implement verification of a particular user login and display a welcome page.",
      "4. Develop a JAVA Servlet Program to implement sessions using HTTP Session Interface.",
      "5. Implement a JSP program using jsp:include and jsp:forward action to display a web page.",
      "6. Develop a JSP program to implement all attributes of Page Directive Tag.",
      "7. Implement a Java program that reads a file name from the user and displays whether the file exists, readable, writable, type and length.",
      "8. Design a Java program that reads a file and displays it on screen with a line number before each line.",
      "9. Implement a Java Servlet program using cookies to remember user preferences.",
      "10. Develop an XML program with CSS properties to display student information such as first name, last name and address.",
      "11. Design a program to create a simple calculator using Servlet and JSP.",
      "12. Create a registration servlet in Java using JDBC and store registration details in the database.",
      "13. Create a servlet that uses Cookies to store the number of times a user has visited servlet.",
      "14. Implement a database connectivity program using Hibernate.",
      "15. Create custom login form using Spring Framework.",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Syllabus",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

// SEMESTER BUTTONS
          SizedBox(
            height: 65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              itemCount: semesters.length,
              itemBuilder: (context, index) {
                final isSelected = selectedSemester == index + 1;

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(semesters[index]),
                    selected: isSelected,
                    selectedColor: const Color(0xFF6C63FF),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) {
                      setState(() {
                        selectedSemester = index + 1;
                        selectedSubject = null;
                      });
                    },
                  ),
                );
              },
            ),
          ),

// SUBJECT BUTTONS
          if (selectedSemester == 5)
            SizedBox(
              height: 75,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: sem5Subjects.keys.map((subject) {
                  final isSelected = selectedSubject == subject;

                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      bottom: 10,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSubject = subject;
                        });
                      },
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6C63FF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            subject,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

// CONTENT
          Expanded(
            child: selectedSubject == null
                ? _buildSelectSubject()
                : _buildSyllabus(selectedSubject!),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectSubject() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.menu_book_rounded,
              size: 70,
              color: Color(0xFF6C63FF),
            ),
            SizedBox(height: 15),
            Text(
              "Select a subject",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Choose a subject above to view its syllabus.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyllabus(String subject) {
    final
    modules
    =
    sem5Subjects
    [
    subject
    ]
    !;

    return
      ListView
        (
        padding
            :
        const
        EdgeInsets
            .
        fromLTRB
          (
            16
            ,
            5
            ,
            16
            ,
            30
        )
        ,
        children
            :
        [

// SUBJECT HEADER
          Container
            (
            padding
                :
            const
            EdgeInsets
                .
            all
              (
                20
            )
            ,
            margin
                :
            const
            EdgeInsets
                .
            only
              (
                bottom
                    :
                15
            )
            ,
            decoration
                :
            BoxDecoration
              (
              gradient
                  :
              const
              LinearGradient
                (
                colors
                    :
                [
                  Color
                    (
                      0xFF6C63FF
                  )
                  ,
                  Color
                    (
                      0xFF8179FF
                  )
                  ,
                ]
                ,
              )
              ,
              borderRadius
                  :
              BorderRadius
                  .
              circular
                (
                  22
              )
              ,
            )
            ,
            child
                :
            Row
              (
              children
                  :
              [
                const
                CircleAvatar
                  (
                  radius
                      :
                  27
                  ,
                  backgroundColor
                      :
                  Colors
                      .
                  white
                  ,
                  child
                      :
                  Icon
                    (
                    Icons
                        .
                    book_rounded
                    ,
                    color
                        :
                    Color
                      (
                        0xFF6C63FF
                    )
                    ,
                    size
                        :
                    30
                    ,
                  )
                  ,
                )
                ,

                const
                SizedBox
                  (
                    width
                        :
                    15
                )
                ,

                Expanded
                  (
                  child
                      :
                  Text
                    (
                    subject
                    ,
                    style
                        :
                    const
                    TextStyle
                      (
                      color
                          :
                      Colors
                          .
                      white
                      ,
                      fontSize
                          :
                      20
                      ,
                      fontWeight
                          :
                      FontWeight
                          .
                      bold
                      ,
                    )
                    ,
                  )
                  ,
                )
                ,
              ]
              ,
            )
            ,
          )
          ,

// MODULES / LAB PROGRAMS
          ...
          modules
              .
          asMap
            (
          )
              .
          entries
              .
          map
            (
                  (entry) {
                final
                index
                =
                    entry
                        .
                    key;
                final
                content
                =
                    entry
                        .
                    value;

                final
                isModule
                =
                content
                    .
                startsWith
                  (
                    "Module"
                );

                return
                  Container
                    (
                    margin
                        :
                    const
                    EdgeInsets
                        .
                    only
                      (
                        bottom
                            :
                        14
                    )
                    ,
                    padding
                        :
                    const
                    EdgeInsets
                        .
                    all
                      (
                        18
                    )
                    ,
                    decoration
                        :
                    BoxDecoration
                      (
                      color
                          :
                      Colors
                          .
                      white
                      ,
                      borderRadius
                          :
                      BorderRadius
                          .
                      circular
                        (
                          18
                      )
                      ,
                      boxShadow
                          :
                      [
                        BoxShadow
                          (
                          color
                              :
                          Colors
                              .
                          black
                              .
                          withOpacity
                            (
                              0.05
                          )
                          ,
                          blurRadius
                              :
                          8
                          ,
                          offset
                              :
                          const
                          Offset
                            (
                              0
                              ,
                              3
                          )
                          ,
                        )
                        ,
                      ]
                      ,
                    )
                    ,
                    child
                        :
                    Column
                      (
                      crossAxisAlignment
                          :
                      CrossAxisAlignment
                          .
                      start
                      ,
                      children
                          :
                      [

                        if
                        (
                        isModule
                        )
                          Text
                            (
                            content
                                .
                            split
                              (
                                "\n"
                            )
                                .
                            first
                            ,
                            style
                                :
                            const
                            TextStyle
                              (
                              color
                                  :
                              Color
                                (
                                  0xFF6C63FF
                              )
                              ,
                              fontSize
                                  :
                              18
                              ,
                              fontWeight
                                  :
                              FontWeight
                                  .
                              bold
                              ,
                            )
                            ,
                          )
                        ,

                        if
                        (
                        isModule
                        )
                          const
                          SizedBox
                            (
                              height
                                  :
                              10
                          )
                        ,

                        Text
                          (
                          isModule
                              ?
                          content
                              .
                          substring
                            (
                            content
                                .
                            indexOf
                              (
                                "\n"
                            )
                                +
                                1
                            ,
                          )
                              :
                          content
                          ,
                          style
                              :
                          const
                          TextStyle
                            (
                            fontSize
                                :
                            15
                            ,
                            height
                                :
                            1.6
                            ,
                            color
                                :
                            Colors
                                .
                            black87
                            ,
                          )
                          ,
                        )
                        ,
                      ]
                      ,
                    )
                    ,
                  );
              }
          )
          ,
        ]
        ,
      );
  }
}