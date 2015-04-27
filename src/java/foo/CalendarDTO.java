package foo;

/**
 * Bean used for the servlet for the full calendar
 * This is used to set and get the variables retrieved from the database
 * @author ajh3
 */
public class CalendarDTO {
    //declaration of my variables
    public int id;
    public String title;
    public String start;
    public String end;
    public String color;
    //Getters and setters for the variables
    public String getColor() {
        return color;
    }
    public void setColor(String color) {
        this.color = color;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getStart() {
        return start;
    }
    public void setStart(String start) {
        this.start = start;
    }
    public String getEnd() {
        return end;
    }
    public void setEnd(String end) {
        this.end = end;
    }
 
}
