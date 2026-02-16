pragma Singleton
import QtQuick

QtObject {
    // Helper function to format playtime
    function formatPlaytime(seconds: int): string {
        if (seconds === 0)
            return "Not played";

        var hours = Math.floor(seconds / 3600);
        var minutes = Math.floor((seconds % 3600) / 60);

        if (hours == 0 && minutes == 1) {
            return "1 Minute";
        }
        if (hours == 0 && minutes > 1) {
            return minutes + " Minutes";
        }
        if (hours == 1) {
            return "1 Hour";
        }
        if (hours > 1) {
            return hours + " Hours";
        }
    }

    // Helper function to format lastPlayed date
    function formatLastPlayed(lastPlayed: int): string {
        // Never Played
        if (!lastPlayed) {
            return "Never Played";
        }

        const playedDate = new Date(lastPlayed);
        const today = new Date();

        // Reset time components to compare dates only
        today.setHours(0, 0, 0, 0);
        playedDate.setHours(0, 0, 0, 0);

        // Calculate difference in days
        const diffTime = today - playedDate;
        const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

        // Configuration
        const RECENT_DAYS_THRESHOLD = 30;

        // Default year is 1970 -> not played
        if (playedDate.getFullYear() == 1970) {
            return "Not Played";
        }

        // Today
        if (diffDays === 0) {
            return "Played Today";
        }

        // Yesterday
        if (diffDays === 1) {
            return "Played Yesterday";
        }

        // Recent days (within threshold)
        if (diffDays < RECENT_DAYS_THRESHOLD) {
            return "Played " + diffDays + " days ago";
        }

        // Older dates - show month abbreviation and year
        return "Played on " + Qt.formatDate(lastPlayed, "MMM. yyyy");
    }
}
