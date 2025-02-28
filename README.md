![home_screenshot](assets/images/home_page_framed.png)

# TrackIt – Simple & Fun Habit Tracker  

**TrackIt** is a lightweight, engaging habit tracker that helps you build and maintain daily habits effortlessly. No sign-ups, no accounts—just open the app and start tracking! 🚀  

## ✨ Features  
- **Daily Habit Logging** – Mark your habit as complete every day.  
- **Habit Streaks** – Stay motivated with streak tracking.  
- **Calendar Heatmap View** – Visualize your progress over time.  
- **Engaging UI & Gamification** – Unlock achievements and enjoy a delightful tracking experience.
- **Offline Support** – Works completely offline with local storage.  

## 🖥️ Tech Stack  
- **Flutter** – Cross-platform mobile development  
- **Hive** – Local storage for tracking habits

## 🎯 Goals & Scope
TrackIt is a single-user experience with no backend or authentication required. The focus is on delivering a seamless and enjoyable habit tracking interface. The app is designed to work fully offline, allowing users to track their habits anytime, anywhere.

## 🏆 Showcase
### Deployed Web App
You can try TrackIt on the web! Check out the deployed version [here](https://trackit-habittracker.web.app/) and explore how it can help you build and maintain your daily habits.

### Screenshots
Below are some screenshots showcasing the key features of TrackIt:

### Home Screen
This is where you can view your daily habits and mark them as complete. You can also create, edit, and delete habits.

|  |  |
|-------|------|
| ![home_page](assets/images/home_page_framed_bigger.png) | **Heatmap**: The Heatmap visualizes your progress over time. It uses a color gradient to show how many habits you have completed each day. The darker the color, the more habits you have completed. <br><br> **Streaks**: Your Streaks are tracked to motivate you. Every day you complete a habit, your streak increases. <br><br> **Achievement Unlocked**: As you continue to track and complete your habits, you will unlock various achievements. |
| | |

### Profile Screen
This is where you can see your achievements and progress in one place. It gives you a high-level overview of your journey and rewards you for consistency.

|  |  |
|-------|------|
| ![profile_page](assets/images/profile_page_framed.png) | **Achievements**: On the **Profile Screen**, you can view the achievements you have unlocked. These achievements act as badges that showcase your progress and dedication in building habits. <br><br> For instance: <br><br> **First Habit:** Awarded for completing your first habit. <br><br> **Streak Master:** Awarded for reaching a streak of 7 days. <br><br> **Completionist:** Awarded after completing 100 habits. |


## 🚀 Getting Started  
### Prerequisites  
- Install [Flutter](https://flutter.dev/docs/get-started/install)

### Running the App
- Clone the repository:  
  ```bash  
  git clone https://github.com/SQ77/trackIt.git  
  cd trackIt  
  ```  
- Install dependencies:  
  ```bash  
  flutter pub get  
  ```  
- Run the app:  
  ```bash  
  flutter run  
  ```

## 📜 Summary of Design Decisions  
- **Minimalist yet Fun UI:** A balance between simplicity and engagement through animations and gamification.
- **Optimized for Quick Logging:** Users can log habits with minimal effort to encourage consistency.
- **Local Storage:** Ensuring a smooth offline experience with Hive.


## Feature Ideas & Constraints

This section documents potential features or tasks that could significantly enhance the app but were unable to be implemented due to time constraints. These are ideas or improvements that the development team would consider adding in the future, based on time, resources, or priority.

### Potential Features

- **Interactive Dashboard**  
A more detailed dashboard for tracking user progress, displaying data visualizations like graphs for streaks, and completed habits over time.

- **Social Sharing**  
The ability to share achievements and completed habits on social media. Users could share a post or badge showing off their progress, increasing visibility and encouraging engagement.

- **Customizable Notifications**  
Let users set personalized reminders and notifications for specific habits, including options for push notifications, in-app reminders, or emails.

- **Habit History & Trends**  
A history feature that shows trends in the user’s habit data, such as how often certain habits were completed over time. It would allow users to reflect on their consistency and identify patterns in their behavior.

- **Engaging Animations**  
Enhance the user experience with more engaging and dynamic animations, such as the 3D rotation effect on achievement badges, similar to Apple Fitness.

### Constraints

- **Limited Time for Implementation**  
  Due to limited time, only core features (like tracking completed habits and achievement system) were prioritized. More advanced features, such as personalized progress tracking, could not be implemented within the current project timeline.

- **User Customization**  
  Customizing habit categories or personalizing the look and feel of the app is an idea for future improvements. However, this would require extra development resources and time that were unavailable in the current scope.

