import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/portfolio_models.dart';

class Data {
  static const webTitle = 'Arone Jerome - Mobile Software Engineer';
  static const name = 'Arone Jerome Malicse';
  static const role = 'Mobile Software Engineer';
  static const phoneNumber = '09924207736';
  static const email = 'arone.portfolio@gmail.com';
  static const location = 'General Trias, Cavite';
  static const birthday = '12 September';
  static const avatar = 'assets/images/ako.jpg';

  static const facebookUrl = 'https://www.facebook.com/jejeromeee/';
  static const instagramUrl = 'https://www.instagram.com/rejomeee/';
  static const githubUrl = 'https://github.com/Rejomeee/';
  static const linkedInUrl =
      'https://www.linkedin.com/in/arone-jerome-malicse-106a85188/';
  static const portfolioUrl = 'https://rejomeee.github.io/arone-portfolio/';
  static const cvUrl = 'https://bit.ly/aronemalicseresume';

  static const homeSentence =
      '“One of my most productive days was throwing away 1000 lines of code.”';
  static const homeAuthor = 'Ken Thompson';

  static const aboutFacts = {
    'Name': name,
    'Location': location,
    'Birthday': birthday,
    'Email': email,
  };

  static const educationTitle = 'Bachelor of Science in Information Technology';
  static const educationDetail = '2015 - 2019 · AMA Computer College - Cavite';

  static const aboutMe = [
    "I'm a mobile software engineer who looks for practical solutions to everyday problems. Flutter is where I'm strongest. I ship with it, and I connect it to native Android and iOS when the product needs to go deeper. I also work with React on the web.",
    "I use AI as part of how I build, and I'm comfortable putting it to work on real product problems. I like working with a team, and I care about clear communication, solid testing, and an experience people actually enjoy.",
  ];

  static const experiences = [
    PortfolioExperience(
      company: 'Maya Philippines, Inc.',
      roles: [
        PortfolioRole(
          details: [
            DetailRow(
              label: 'May 18, 2022 – Present',
              value: 'Software Engineer',
            ),
            DetailRow(
              label: 'Task',
              value:
                  'Build mobile products for Maya, a digital bank, and for Maya Business.',
            ),
            DetailRow(
              label: 'Description',
              value:
                  'I work on Maya — savings, loans, and cards — and on Maya Business, the Maya app for businesses. The work is Flutter-first, including the places where Flutter talks to native Android and iOS.',
            ),
          ],
          tools: [
            'Flutter',
            'Dart',
            'Android',
            'iOS',
            'Git',
          ],
        ),
      ],
    ),
    PortfolioExperience(
      company: 'Outsource',
      roles: [
        PortfolioRole(
          details: [
            DetailRow(
              label: 'Nov. 2021',
              value: 'Lead Mobile Software Engineer',
            ),
            DetailRow(
              label: 'Task',
              value:
                  'To provide professional services in the form of a mobile app for iOS.',
            ),
            DetailRow(
              label: 'Description',
              value:
                  'I was assigned to develop an iOS app. We used Flutter on iPad and iPhone, and I also deployed the application to the App Store.',
            ),
          ],
          tools: [
            'Flutter',
            'Dart',
            'Git',
            'Android Studio',
            'Firebase',
            'Xcode',
            'Google Map Services',
            'Socket',
          ],
        ),
      ],
    ),
    PortfolioExperience(
      company: 'LEENTech Network Solutions',
      roles: [
        PortfolioRole(
          details: [
            DetailRow(
              label: 'Aug. 2020',
              value: 'Hybrid Software Engineer / Fullstack Mobile Developer',
            ),
            DetailRow(
              label: 'Task',
              value:
                  'To provide the Android front end and back-end solutions for APIs.',
            ),
            DetailRow(
              label: 'Description',
              value:
                  'I was assigned to develop an Android app using Flutter for the front end, and to create and integrate APIs.',
            ),
          ],
          tools: [
            'Flutter',
            'API',
            'Firebase',
            'Laravel',
            'Dart',
            'Xcode',
            'Git',
            'Android Studio',
          ],
        ),
        PortfolioRole(
          details: [
            DetailRow(
              label: 'Aug. 2019',
              value: 'Fullstack Software Engineer',
            ),
            DetailRow(
              label: 'Task',
              value:
                  'To provide the front end for the app and back-end solutions for APIs.',
            ),
            DetailRow(
              label: 'Description',
              value:
                  'We developed a self-monitoring app. I was assigned to the front and back of the mobile app using Ionic, and to integrate Laravel APIs.',
            ),
          ],
          tools: [
            'Ionic',
            'Angular',
            'NodeJs',
            'Bootstrap',
            'Git',
            'Cpanel',
          ],
        ),
        PortfolioRole(
          details: [
            DetailRow(
              label: 'Jan. 2019',
              value: 'Fullstack Web Developer',
            ),
            DetailRow(
              label: 'Task',
              value:
                  'To provide front-end and back-end solutions for different websites.',
            ),
            DetailRow(
              label: 'Description',
              value:
                  "This was my first assignment building a website. I supported a maintenance project, kept it stable, and enhanced it for the client's needs. Later I assisted the mobile department with APIs.",
            ),
          ],
          tools: [
            'PHP',
            'Zend Framework',
            'API',
            'Cpanel',
            'Git',
            'Bootstrap',
          ],
        ),
      ],
    ),
  ];

  static const skillsToGrow = [
    'Team Management',
    'Efficient Debugging',
    'Leadership',
    'Clean Architectural Structure',
    'Different types of unit testing',
    'Knowledge of quality standards',
    'Documentation',
  ];

  static const projects = [
    PortfolioProject(
      title: 'Project Management App for Construction Firm',
      summary:
          'My role was to develop an iOS application using Flutter and Dart, with Google Maps, REST APIs, Bloc, and Xcode. It was deployed to the App Store by invitation, because it was exclusive to one company.',
      features: [
        'Project management',
        'Realtime chat with image, voice, and text',
        'Realtime notification',
        'Project calendar',
        'Image uploading with compression',
        'User profile management',
        'User authentication',
      ],
      tools: [
        'Flutter',
        'Laravel',
        'Xcode',
        'Google Map Services',
        'Socket.IO',
        'Rive',
      ],
    ),
    PortfolioProject(
      title: 'Delivery App',
      summary:
          'My role was to develop the front-end and back-end modules and integrate the APIs.',
      features: [
        'Driver booking',
        'User authentication with OTP',
        'Social authentication',
        'Profile management',
        'Messaging',
        'Payment gateway',
      ],
      tools: [
        'Flutter',
        'Android Studio',
        'Firebase',
        'Promotexter',
      ],
    ),
    PortfolioProject(
      title: 'Social Media App',
      summary:
          'My role was to develop and integrate APIs for the Android and iOS modules.',
      features: [
        'Upload images',
        'Filter creation',
        'Realtime chat',
        'User authentication with social login',
      ],
      tools: [
        'Ionic',
        'Opoink',
        'Zend Framework',
        'Android Studio',
      ],
    ),
  ];

  static const socialLinks = [
    SocialLink(
      label: 'GitHub',
      url: githubUrl,
      icon: FontAwesomeIcons.github,
    ),
    SocialLink(
      label: 'LinkedIn',
      url: linkedInUrl,
      icon: FontAwesomeIcons.linkedinIn,
    ),
    SocialLink(
      label: 'Instagram',
      url: instagramUrl,
      icon: FontAwesomeIcons.instagram,
    ),
    SocialLink(
      label: 'Facebook',
      url: facebookUrl,
      icon: FontAwesomeIcons.facebookF,
    ),
  ];
}
