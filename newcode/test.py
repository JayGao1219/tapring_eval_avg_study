import tkinter as tk


def flash(event, idx=0):
    print(idx)
    flashing_colors = ['darkblue', 'yellow']
    w.itemconfigure(w.find_withtag('blue_rectangle'), fill=flashing_colors[idx])
    window.after(100, flash, 'dummy', (idx+1) % 2)


if __name__ == '__main__':

    window = tk.Tk()

    w = tk.Canvas(window, width=1366, height=766)
    w.configure(background="black")
    w.pack()

    blue_rectangle = w.create_rectangle(483, 480, 683, 680, fill="darkblue")
    red_rectangle = w.create_rectangle(683, 480, 883, 680, fill="red", tags=('blue_rectangle',))
    yellow_rectangle = w.create_rectangle(483, 280, 683, 480, fill="yellow")
    green_rectangle = w.create_rectangle(683, 280, 883, 480, fill="green")

    w.bind("<ButtonPress-1>", flash)

    window.mainloop()
